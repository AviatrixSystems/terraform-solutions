import { Actions, ConfigurationState } from "types/store";

const initialState: ConfigurationState = {
  isInProgress: false,
  error: null,
  progress: null,
  processedData: {},
  step: 1,
  isFirstTime: true,
};

export default function configuration(
  state: ConfigurationState = initialState,
  action: Actions
) {
  switch (action.type) {
    case "SET_MACHINE_STATE":
      return action.payload;
    case "SET_FAILURE_RESPONSE_STATUS":
    case "SET_SUCCESS_RESPONSE_STATUS":
    case "CLEAR_RESPONSE_STATUS":
    case "SET_STEP_AND_ACTION_STATUS":
    case "SET_VARIABLES":
      return { ...state, ...action.payload };
    case "SET_ACTION_PENDING":
      return { ...state, actionPending: action.payload };
    case "SET_IS_FIRST_TIME":
      return { ...state, isFirstTime: action.payload };
    case "SET_IS_IN_PROGRESS":
      return { ...state, isInProgress: action.payload };
    default:
      return state;
  }
}
