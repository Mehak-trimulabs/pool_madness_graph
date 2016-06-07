import React from 'react'
import Relay from 'react-relay'
import { Router, Route, browserHistory, applyRouterMiddleware } from 'react-router'
import useRelay from 'react-router-relay'

import Layout from './components/layout/layout'
import App from './components/app'
import PoolList from './components/pools/pool_list'
import Pool from './components/pools/pool'

function NoMatch() {
  return <Layout>The page you are looking for could not be found :(</Layout>
}

const ListsQueries = {
  lists: () => Relay.QL`query { lists }`
}

const PoolQueries = {
  pool: () => Relay.QL`
    query {
      pool(model_id: $poolId)
    }
  `
}

export default function() {
  return (
    <Router history={browserHistory} render={applyRouterMiddleware(useRelay)} environment={Relay.Store}>
      <Route path="/" component={App}>
        <Route component={Layout}>
          <Route path="pools" component={PoolList} queries={ListsQueries}/>
          <Route path="pools/:poolId" component={Pool} queries={PoolQueries}/>
        </Route>
        <Route path='*' component={NoMatch}/>
      </Route>
    </Router>
  )
}

