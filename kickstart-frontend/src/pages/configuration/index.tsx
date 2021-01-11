import React, { useCallback, useEffect } from "react";
import {
  Redirect,
  Route,
  Switch,
  useHistory,
  useRouteMatch,
} from "react-router-dom";
import { useDispatch, useSelector } from "react-redux";

import Alert from "components/base/alert";
import Steps from "./steps";
import { clearResponseStatus, initialization, setStep } from "store/actions";
import { StepsAside } from "components";
import { useCustomPolling } from "utils";
import { SEC_15 } from "utils/constants";
import { AppState } from "store";
import { CoverImage } from "svgs";

export default function Configuration() {
  const { path } = useRouteMatch();
  const history = useHistory();
  const {
    location: { pathname },
  } = history;
  const {
    responseMessage,
    responseStatus,
    isFirstTime,
    actionPending,
  } = useSelector<AppState, AppState["configuration"]>(
    (state) => state.configuration
  );
  const dispatch = useDispatch();
  const onAlertClose = useCallback(() => {
    dispatch(clearResponseStatus());
  }, [dispatch]);
  useCustomPolling(
    () => {
      if (!isFirstTime) {
        dispatch(setStep(history));
      }
    },
    SEC_15,
    []
  );

  useEffect(() => {
    if (isFirstTime) {
      dispatch(initialization(history));
    }
  }, [isFirstTime, history, dispatch]);

  const stepNo = Number.parseInt(pathname.slice(-1));

  return (
    <>
      <figure>{CoverImage}</figure>
      <section className="configuration-section">
        <div className="content">
          <aside className="left-nav">
            <StepsAside stepNo={stepNo} />
          </aside>
          <section className="right-section">
            {responseStatus && !actionPending && (
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
