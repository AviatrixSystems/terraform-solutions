import React, { useCallback, useEffect } from "react";
import {
  Redirect,
  Route,
  Switch,
  useHistory,
  useRouteMatch,
} from "react-router-dom";
import { useDispatch, useSelector } from "react-redux";

import { StepsAside } from "components";
import Steps from "./steps";
import { getRoute, useCustomPolling } from "utils";
import { AppState } from "store";
import Alert from "components/base/alert";
import { clearResponseStatus, setStep } from "store/actions";
import { CoverImage } from "svgs";
import { ROUTES } from "utils/constants";

export default function Configuration() {
  const { path } = useRouteMatch();
  const history = useHistory();
  const {
    location: { pathname },
  } = history;
  const { step, responseMessage, responseStatus } = useSelector<
    AppState,
    AppState["configuration"]
  >((state) => state.configuration);
  const dispatch = useDispatch();

  const stepNo = Number.parseInt(pathname.slice(-1));

  const onAlertClose = useCallback(() => {
    dispatch(clearResponseStatus());
  }, [dispatch]);

  useEffect(() => {
    if (step !== stepNo) {
      history.push(getRoute(`${ROUTES.configuration}/${step}`));
    }
  }, [step, stepNo]);

  useCustomPolling(
    () => {
      dispatch(setStep());
    },
    15000,
    []
  );

  return (
    <>
      <figure>{CoverImage}</figure>
      <section className="configuration-section">
        <div className="content">
          <aside className="left-nav">
            <StepsAside stepNo={step} />
          </aside>
          <section className="right-section">
            {responseStatus && (
              <Alert
                icon={false}
                onClose={onAlertClose}
                severity={responseStatus === "success" ? "success" : "error"}
              >
                {responseMessage}
              </Alert>
            )}
            <Switch>
              <Route exact path={path}>
                <Redirect to={`${path}/1`} />
              </Route>
              <Route path={`${path}/:stepNo`} component={Steps} />
            </Switch>
          </section>
        </div>
      </section>
    </>
  );
}
