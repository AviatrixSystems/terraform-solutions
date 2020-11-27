import React, { useEffect } from "react";
import {
  Redirect,
  Route,
  Switch,
  useHistory,
  useRouteMatch,
} from "react-router-dom";
import { useSelector } from "react-redux";

import { DebugBar, StepsAside } from "components";
import Steps from "./steps";
import { getRoute } from "utils";
import { ROUTES } from "utils/constants";
import { AppState } from "store";

export default function Configuration() {
  const { path } = useRouteMatch();
  const history = useHistory();
  const {
    location: { pathname },
  } = history;
  const { step } = useSelector<AppState, AppState["configuration"]>(
    (state) => state.configuration
  );
  const stepNo = Number.parseInt(pathname.slice(-1));

  useEffect(() => {
    if (step !== stepNo) {
      history.push(getRoute(`${ROUTES.configuration}/${step}`));
    }
  }, [step, stepNo]);

  return (
    <section className="configuration-section">
      <DebugBar />
      <div className="content">
        <aside className="left-nav">
          <StepsAside stepNo={step} />
        </aside>
        <section className="right-section">
          <Switch>
            <Route exact path={path}>
              <Redirect to={`${path}/1`} />
            </Route>
            <Route path={`${path}/:stepNo`} component={Steps} />
          </Switch>
        </section>
      </div>
    </section>
  );
}
