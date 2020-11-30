import { Actions, ConfigurationState } from "types/store";

const initialState: ConfigurationState = {
  isInProgress: false,
  step: 1,
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
      return { ...state, ...action.payload };
    default:
      return state;
  }
}
