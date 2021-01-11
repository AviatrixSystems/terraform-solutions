import React from "react";
import {
  BrowserRouter as Router,
  Switch,
  Route,
  Redirect,
} from "react-router-dom";
import { Provider, useSelector } from "react-redux";

import { AppBar, LoadingBar, Drawer, InitialModal } from "components";
import { Configuration } from "pages";
import { ROUTES } from "utils/constants";
import configureStore, { AppState } from "store";

const store = configureStore();

function Routes() {
  const { isInProgress } = useSelector<AppState, AppState["configuration"]>(
    (state) => state.configuration
  );
  return (
    <Router>
      <div className="app">
        <InitialModal />
        <AppBar />
        {isInProgress && <LoadingBar />}
        <Drawer />
        <main>
          <Switch>
            <Route path={ROUTES.configuration} component={Configuration} />
            <Route
              path="/"
              component={() => <Redirect to={ROUTES.configuration} />}
            />
            <Route
              path="*"
              component={() => <Redirect to={ROUTES.configuration} />}
            />
          </Switch>
        </main>
      </div>
    </Router>
  );
}

function App() {
  return (
    <Provider store={store}>
      <Routes />
    </Provider>
  );
}

export default App;
