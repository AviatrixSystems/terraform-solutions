import { Actions, ConfigurationState } from "types/store";

export function setMachineState(machineState: ConfigurationState): Actions {
  return {
    type: "SET_MACHINE_STATE",
    payload: machineState,
  };
}
