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
    default:
      return state;
  }
}
