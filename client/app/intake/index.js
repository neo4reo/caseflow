import React from 'react';
import { Provider } from 'react-redux';
import thunk from 'redux-thunk';
import { createStore, applyMiddleware, combineReducers, compose } from 'redux';
import perfLogger from 'redux-perf-middleware';
import IntakeFrame from './IntakeFrame';
import { intakeReducer, mapDataToInitialIntake } from './reducers/intake';
import { rampElectionReducer, mapDataToInitialRampElection } from './reducers/rampElection';
import { rampRefilingReducer, mapDataToInitialRampRefiling } from './reducers/rampRefiling';
import { getReduxAnalyticsMiddleware } from '../util/getReduxAnalyticsMiddleware';

const Intake = (props) => {
  // eslint-disable-next-line no-underscore-dangle
  const composeEnhancers = window.__REDUX_DEVTOOLS_EXTENSION_COMPOSE__ || compose;

  const reducer = combineReducers({
    intake: intakeReducer,
    rampElection: rampElectionReducer,
    rampRefiling: rampRefilingReducer
  });

  const store = createStore(
    reducer,
    {
      intake: mapDataToInitialIntake(props),
      rampElection: mapDataToInitialRampElection(props),
      rampRefiling: mapDataToInitialRampRefiling(props)
    },
    composeEnhancers(applyMiddleware(thunk, perfLogger, getReduxAnalyticsMiddleware('intake')))
  );

  if (module.hot) {
    // Enable Webpack hot module replacement for reducers
    module.hot.accept([
      './reducers/intake',
      './reducers/rampElection',
      './reducers/rampRefiling'
    ],
    () => store.replaceReducer(reducer)
    );
  }

  return <Provider store={store}>
    <IntakeFrame {...props} />
  </Provider>;
};

export default Intake;
