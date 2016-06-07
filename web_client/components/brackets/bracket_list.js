import React from 'react'
import Relay from 'react-relay'

function TeamName(props) {
  if (props.smallScreen) {
    return <div className={`final-four-team final-four-team${props.index}`}>{props.team.name}</div>
  }
  else {
    return <td>{props.team.name}</td>
  }
}

function SmallBracket(props) {
  let bracket = props.bracket
  let finalFourTeams = bracket.final_four.edges.map(edge => edge.node)

  return <a href={`/brackets/${bracket.model_id}`}>
    <div className='bracket-row'>
      <div className='bracket-attributes'>
        <div className='position'>{props.index}.</div>
        <div className='bracket-details'>
          <div className="name">{bracket.name}</div>
          <div className="points">
            <div className="total">{bracket.points}</div>
            <div className="possible">{bracket.possible_points}</div>
          </div>
          <div className="final-four-teams">
            {finalFourTeams.map((team, i) => <TeamName key={team.id} team={team} index={i} smallScreen={true}/>)}
          </div>
        </div>
      </div>
    </div>
  </a>
}


function BracketRow(props) {
  let bracket = props.bracket
  let finalFourTeams = bracket.final_four.edges.map(edge => edge.node)
  let bracketPath = `/brackets/${bracket.model_id}`

  return <tr className='bracket-row'>
    <td>{props.index}.</td>
    <td><a href={bracketPath}>{bracket.name}</a></td>
    <td>{bracket.points}</td>
    <td>{bracket.possible_points}</td>
    {finalFourTeams.map(team => <TeamName key={team.id} team={team}/>)}
  </tr>
}

function TableHeader(props) {
  var headings = ['', 'Name', 'Score', 'Possible', 'Final Four', 'Final Four', 'Second', 'Winner']

  return <thead>
  <tr>
    { headings.map(heading => <th>{heading}</th>) }
  </tr>
  </thead>
}

var Component = React.createClass({
  contextTypes: {
    setPageTitle: React.PropTypes.func.isRequired
  },

  componentWillMount() {
    this.context.setPageTitle('Brackets')
  },

  componentDidMount() {
    let brackets = this.props.pool.brackets.edges.map(edge => edge.node)
    this.context.setPageTitle(`Brackets (${brackets.length} total)`)
  },

  componentWillUnmount() {
    this.context.setPageTitle()
  },

  render() {
    let brackets = this.props.pool.brackets.edges.map(edge => edge.node)

    return <div className='bracket-list'>
      <div className='large-screen'>
        <table className='tables'>
          <TableHeader />
          <tbody>
          {brackets.map((bracket, i) => <BracketRow key={bracket.id} index={i+1} bracket={bracket} />)}
          </tbody>
        </table>
      </div>

      <div className='small-screen'>
        {brackets.map((bracket, i) => <SmallBracket key={bracket.id} index={i+1} bracket={bracket} />)}
      </div>
    </div>
  }
})

export default Relay.createContainer(Component, {
  fragments: {
    pool: () => Relay.QL`
      fragment on Pool {
        brackets(first: 1000) {
          edges {
            node {
              id
              model_id
              name
              points
              possible_points
              final_four(first: 4) {
                edges {
                  node {
                    id
                    name
                  }
                }
              }
            }
          }
        }
      }
    `
  }
})