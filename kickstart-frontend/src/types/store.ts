export type ConfigurationState = {
  step: number;
  isInProgress: boolean;
  responseStatus?: "success" | "failure";
  responseMessage?: string;
  controllerIP?: string;
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
        "step" | "isInProgress" | "controllerIP"
      >;
    };
