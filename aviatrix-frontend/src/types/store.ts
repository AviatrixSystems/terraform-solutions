export type ConfigurationState = {
  step: number;
  isInProgress: boolean;
};

export type Actions = {
  type: "SET_MACHINE_STATE";
  payload: ConfigurationState;
};
