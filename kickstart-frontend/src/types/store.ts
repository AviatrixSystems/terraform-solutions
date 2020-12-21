import {
  GetStepResponse,
  Step2Variables,
  Step3Variables,
  Step6Variables,
} from "./api";

export interface ConfigurationState
  extends Pick<
    GetStepResponse["data"],
    "error" | "processedData" | "progress" | "ips" | "is_advance"
  > {
  step: number;
  isInProgress: boolean;
  responseStatus?: "success" | "failure";
  responseMessage?: string;
  controllerIP?: string;
  actionPending?: number;
  isFirstTime: boolean;
  step2_variables?: Step2Variables["data"];
  step3_variables?: Step3Variables["data"];
  step6_variables?: Step6Variables["data"];
}

export type SetVariableAction = {
  type: "SET_VARIABLES";
  payload:
    | { step2_variables: ConfigurationState["step2_variables"] }
    | { step3_variables: ConfigurationState["step3_variables"] }
    | { step6_variables: ConfigurationState["step6_variables"] };
};

export type Actions =
  | {
      type: "SET_MACHINE_STATE";
      payload: ConfigurationState;
    }
  | {
      type: "SET_SUCCESS_RESPONSE_STATUS";
      payload: Pick<ConfigurationState, "responseStatus" | "responseMessage">;
    }
  | {
      type: "CLEAR_RESPONSE_STATUS";
      payload: Pick<ConfigurationState, "responseStatus" | "responseMessage">;
    }
  | {
      type: "SET_FAILURE_RESPONSE_STATUS";
      payload: Pick<ConfigurationState, "responseStatus" | "responseMessage">;
    }
  | {
      type: "SET_STEP_AND_ACTION_STATUS";
      payload: Pick<
        ConfigurationState,
        | "step"
        | "isInProgress"
        | "controllerIP"
        | "error"
        | "processedData"
        | "progress"
        | "ips"
        | "is_advance"
      >;
    }
  | {
      type: "SET_ACTION_PENDING";
      payload: ConfigurationState["actionPending"];
    }
  | {
      type: "SET_IS_FIRST_TIME";
      payload: ConfigurationState["isFirstTime"];
    }
  | {
      type: "SET_IS_IN_PROGRESS";
      payload: ConfigurationState["isInProgress"];
    }
  | SetVariableAction;
