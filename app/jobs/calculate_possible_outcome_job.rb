class CalculatePossibleOutcomeJob < ActiveJob::Base
  def perform(tournament_id, timestamp, opts={})
    opts = {update_db: true}.merge(opts)

    ActiveRecord::Base.cache do
      tournament = Tournament.find(tournament_id)
      pools = tournament.pools.includes(brackets: [:picks])
      outcome_set = PossibleOutcomeSet.new(tournament: tournament)
      max_slot_bits = outcome_set.max_slot_bits

      bits = pop_bits(tournament_id, timestamp)

      until bits > max_slot_bits
        outcome = outcome_set.update_outcome(bits)
        pools.each do |pool|
          outcome.get_best_possible(pool).each do |bracket, rank|
            update_redis_bracket(pool, timestamp, bracket, rank)
          end
        end

        bits = pop_bits(tournament_id, timestamp)
      end

      if opts[:update_db]
        Sidekiq.redis do |redis|
          pools.each do |pool|
            best_hash = redis.hgetall(self.class.outcome_brackets_key(tournament_id, timestamp, pool.id))
            pool.brackets.where.not(id: best_hash.keys.map(&:to_i)).map(&:bracket_point).each {|bp| bp.update(best_possible: 60000)}
            best_hash.each do |bracket_id, rank|
              Bracket.find(bracket_id.to_i).bracket_point.update(best_possible: rank.to_i)
            end
          end
        end
      end
    end
  end

  def self.outcome_brackets_key(tournament_id, timestamp, pool_id)
    "outcomebrackets_#{tournament_id}_#{timestamp}_#{pool_id}"
  end

  private

  def update_redis_bracket(pool, timestamp, bracket, rank)
    key = self.class.outcome_brackets_key(pool.tournament_id, timestamp, pool.id)

    Sidekiq.redis do |redis|
      if redis.hexists(key, bracket.id)
        current_rank = redis.hget(key, bracket.id)
        redis.hset(key, bracket.id, rank) if rank < current_rank.to_i
      else
        redis.hset(key, bracket.id, rank)
      end
    end
  end

  def pop_bits(tournament_id, timestamp)
    Sidekiq.redis { |r| r.incr(UpdatePossibleOutcomesJob.outcome_set_key(tournament_id, timestamp)) }
  end
end