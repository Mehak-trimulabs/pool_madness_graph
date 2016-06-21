import React from 'react'
import Relay from 'react-relay'
import { times } from 'lodash'

function TableHeader(props) {
  if (props.brackets.length > 0) {
    let headings = ['Name', 'Final Four', 'Final Four', 'Second', 'Winner', 'Tie', 'Status']
    return <thead>
      <tr>
        {headings.map((heading, i) => <th key={`heading-${i}`}>{heading}</th>)}
      </tr>
    </thead>
  } else {
    return false
  }
}

function BracketStatus(props) {
  switch(props.status) {
    case 'ok':
      return <span className="badge-success">OK</span>
    case 'unpaid':
      return <span className="badge-alert">Unpaid</span>
    case 'incomplete':
      return <span className="badge-error">Incomplete</span>
    default:
      return <span>Unknown</span>
  }
}

function BracketRow(props) {
  let bracket = props.bracket
  let finalFourTeams = bracket.final_four.edges.map(edge => edge.node)
  let bracketPath = `/brackets/${bracket.model_id}`
  let emptyTeamsSize = 4 - finalFourTeams.length

  return <tr className={`bracket-row bracket-${bracket.model_id}`}>
    <td className='bracket-name'><a href={bracketPath}>{bracket.name}</a></td>
    {finalFourTeams.map(team => <td className='bracket-final-four' key={team.id}>{team.name}</td>)}
    {times(emptyTeamsSize, x => <td className='bracket-final-four' key={`bracket-${bracket.id}-empty-${x}`}> </td>)}
    <td className='bracket-tie-breaker'>{bracket.tie_breaker}</td>
    <td className='bracket-status'><BracketStatus status={bracket.status} /></td>
  </tr>
}

function NewBracketButton(props) {
  var buttonText, buttonClass
  if (props.brackets.length > 0) {
    buttonText = "Another Bracket Entry"
    buttonClass = "minor"
  } else {
    buttonText = "New Bracket Entry"
    buttonClass = ""
  }

  return <form method="post" action={`/pools/${props.pool.model_id}/brackets`}>
    <button className={buttonClass}>{buttonText}</button>
  </form>
}

var Component = React.createClass({
  contextTypes: {
    setPageTitle: React.PropTypes.func.isRequired
  },

  componentWillMount() {
    this.context.setPageTitle("My Brackets")
  },

  componentWillUnmount() {
    this.context.setPageTitle()
  },

  brackets() {
    return this.props.pool.brackets.edges.map(edge => edge.node)
  },

  render() {
    let pool = this.props.pool
    let brackets = this.brackets()

    return <div className='user-bracket-list'>
      <div className='large-screen'>
        <table className='table-minimal'>
          <TableHeader brackets={brackets} />
          <tbody>
          {brackets.map(bracket => <BracketRow key={bracket.id} bracket={bracket} />)}
          </tbody>
        </table>
      </div>
      <div className='actions'>
        <NewBracketButton pool={pool} brackets={brackets} />
      </div>
    </div>
  }
})

export default Relay.createContainer(Component, {
  fragments: {
    pool: () => Relay.QL`
      fragment on Pool {
        model_id
        brackets(first: 1000) {
          edges {
            node {
              id
              model_id
              name
              tie_breaker
              status
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