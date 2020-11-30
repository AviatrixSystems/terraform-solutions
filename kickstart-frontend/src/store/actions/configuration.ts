import { Dispatch } from "redux";
import {
  AddAWSCredentialsResponse,
  ControllerPayload,
  DeleteConfigResponse,
  GetStepResponse,
} from "types/api";
import { Actions, ConfigurationState } from "types/store";
import { getApiResponse } from "utils";

export function setMachineState(machineState: ConfigurationState): Actions {
  return {
    type: "SET_MACHINE_STATE",
    payload: machineState,
  };
}

export function setSuccessResponseStatus(
  responseMessage: string = "Request successful"
): Actions {
  return {
    type: "SET_SUCCESS_RESPONSE_STATUS",
    payload: {
      responseMessage,
      responseStatus: "success",
    },
  };
}

export function setFailureResponseStatus(
  responseMessage: string = "Request failed"
): Actions {
  return {
    type: "SET_FAILURE_RESPONSE_STATUS",
    payload: {
      responseMessage,
      responseStatus: "failure",
    },
  };
}

export function clearResponseStatus(): Actions {
  return {
    type: "CLEAR_RESPONSE_STATUS",
    payload: {
      responseMessage: undefined,
      responseStatus: undefined,
    },
  };
}

export function setStepAndActionStatus(
  step: number,
  isInProgress: boolean,
  controllerIP?: string
): Actions {
  return {
    type: "SET_STEP_AND_ACTION_STATUS",
    payload: { isInProgress, step, controllerIP },
  };
}

export function deleteConfig() {
  return (dispatch: any) => {
    getApiResponse<DeleteConfigResponse>({
      urlName: "delete_config",
    })
      .then(({ data: { message } }) => {
        dispatch(setSuccessResponseStatus(message));
        dispatch(setStep());
      })
      .catch(() => {
        dispatch(setFailureResponseStatus());
      });
  };
}

export function setStep() {
  return (dispatch: Dispatch) => {
    getApiResponse<GetStepResponse>({ urlName: "get_status" })
      .then(({ data: { data } }) => {
        if (Object.keys(data).length) {
          const stepNo =
            data.status === "success" && data.state < 8
              ? data.state + 1
              : data.state;
          dispatch(
            setStepAndActionStatus(
              stepNo === 0 ? 1 : stepNo,
              data.status === "in-progress",
              data.controllerIP
            )
          );

          if (data.status === "failed") {
            dispatch(
              setFailureResponseStatus("Previous action is not completed")
            );
          }
        }
      })
      .catch((error) => {
        if (error?.response?.data?.message !== "No record found") {
          dispatch(setFailureResponseStatus(error?.response?.data?.message));
        }
      });
  };
}

export function addAWSCredentials(data: {
  key_id: string;
  secret_key: string;
}) {
  return (dispatch: any) => {
    getApiResponse<AddAWSCredentialsResponse>({
      urlName: "add_credentials",
      data,
    })
      .then(({ data: { message } }) => {
        dispatch(setSuccessResponseStatus(message));
        dispatch(setStep());
      })
      .catch(() => {
        dispatch(setFailureResponseStatus());
      });
  };
}

export function launchController(data: ControllerPayload) {
  return (dispatch: any) => {
    getApiResponse<any>({
      urlName: "launch_controller",
      data,
    })
      .then(({ data }) => {
        dispatch(setSuccessResponseStatus(data?.message));
        dispatch(setStep());
      })
      .catch(() => {
        dispatch(setFailureResponseStatus());
      });
  };
}

export function launchTransit(data: { command: boolean }) {
  return (dispatch: any) => {
    getApiResponse<any>({
      urlName: "launch_transit_aws",
      data,
    })
      .then(({ data }) => {
        dispatch(setSuccessResponseStatus(data?.message));
        dispatch(setStep());
      })
      .catch(() => {
        dispatch(setFailureResponseStatus());
      });
  };
}

export function launchEC2(data: { command: boolean }) {
  return (dispatch: any) => {
    getApiResponse<any>({
      urlName: "launch_ec2",
      data,
    })
      .then(({ data }) => {
        dispatch(setSuccessResponseStatus(data?.message));
        dispatch(setStep());
      })
      .catch(() => {
        dispatch(setFailureResponseStatus());
      });
  };
}

export function launchSpokevpc(data: { keyname: string }) {
  return (dispatch: any) => {
    getApiResponse<any>({
      urlName: "launch_spokevpc",
      data,
    })
      .then(({ data }) => {
        dispatch(setSuccessResponseStatus(data?.message));
        dispatch(setStep());
      })
      .catch(() => {
        dispatch(setFailureResponseStatus());
      });
  };
}

export function launchTransitAzure(data: {
  azure_subscription_id: string;
  azure_directory_id: string;
  azure_application_id: string;
  azure_application_key: string;
}) {
  return (dispatch: any) => {
    getApiResponse<any>({
      urlName: "launch_transit_azure",
      data,
    })
      .then(({ data }) => {
        dispatch(setSuccessResponseStatus(data?.message));
        dispatch(setStep());
      })
      .catch(() => {
        dispatch(setFailureResponseStatus());
      });
  };
}

export function skipTransitAzure(data: { command: boolean }) {
  return (dispatch: any) => {
    getApiResponse<any>({
      urlName: "skip_transit_azure",
      data,
    })
      .then(({ data }) => {
        dispatch(setSuccessResponseStatus(data?.message));
        dispatch(setStep());
      })
      .catch(() => {
        dispatch(setFailureResponseStatus());
      });
  };
}

export function builtTransit(data: { command: boolean }) {
  return (dispatch: any) => {
    getApiResponse<any>({
      urlName: "built_transit",
      data,
    })
      .then(({ data }) => {
        dispatch(setSuccessResponseStatus(data?.message));
        dispatch(setStep());
      })
      .catch(() => {
        dispatch(setFailureResponseStatus());
      });
  };
}
