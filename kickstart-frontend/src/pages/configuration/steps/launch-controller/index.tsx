import React, { useMemo } from "react";
import { useDispatch, useSelector } from "react-redux";
import { useHistory } from "react-router-dom";

import { AppState } from "store";
import AdvanceForm from "./advance-form";
import StandardForm from "./standard-form";

export default function LaunchController() {
  const dispatch = useDispatch();
  const history = useHistory();
  const state = useSelector<AppState, AppState["configuration"]>(
    (state) => state.configuration
  );
  const { is_advance, step, processedData = {}, step2_variables } = state;
  const pageDisabled = useMemo(() => step > 2, [step]);

  return is_advance ? (
    <AdvanceForm
      dispatch={dispatch}
      history={history}
      processedData={processedData}
      pageDisabled={pageDisabled}
      step2_variables={step2_variables}
    />
  ) : (
    <StandardForm
      dispatch={dispatch}
      history={history}
      processedData={processedData}
      pageDisabled={pageDisabled}
    />
  );
}
