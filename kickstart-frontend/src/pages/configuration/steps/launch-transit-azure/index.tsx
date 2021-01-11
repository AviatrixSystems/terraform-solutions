import React from "react";
import { useDispatch, useSelector } from "react-redux";
import { useHistory } from "react-router-dom";

import { AppState } from "store";
import AdvanceForm from "./advance-form";
import StandardForm from "./standard-form";

export default function LaunchTransitAzure() {
  const dispatch = useDispatch();
  const history = useHistory();
  const { is_advance, step, processedData = {}, step6_variables } = useSelector<
    AppState,
    AppState["configuration"]
  >((state) => state.configuration);
  const { avaitrixTransitAzure } = processedData;
  const pageDisabled = step > 6 && avaitrixTransitAzure?.state !== "no";

  return is_advance ? (
    <AdvanceForm
      step6_variables={step6_variables}
      dispatch={dispatch}
      history={history}
      pageDisabled={pageDisabled}
      processedData={processedData}
    />
  ) : (
    <StandardForm
      dispatch={dispatch}
      history={history}
      pageDisabled={pageDisabled}
      processedData={processedData}
    />
  );
}
