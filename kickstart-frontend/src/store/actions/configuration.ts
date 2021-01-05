import { Dispatch } from "redux";
import { AppState } from "store";
import {
  AddAWSCredentialsResponse,
  ControllerPayload,
  DeleteConfigResponse,
  GetStepResponse,
  Step2Variables,
  Step3Variables,
  Step6Variables,
  UrlConfigs,
} from "types/api";
import { Actions, ConfigurationState, SetVariableAction } from "types/store";
import {
  getApiResponse,
  getCurrentPageNo,
  getRoute,
  redirectToNextPage,
} from "utils";
import { ROUTES } from "utils/constants";

export function setActionPending(
  actionPending: ConfigurationState["actionPending"]
): Actions {
  return {
    type: "SET_ACTION_PENDING",
    payload: actionPending,
  };
}

export function setIsFirstTime(isFirstTime: boolean): Actions {
  return {
    type: "SET_IS_FIRST_TIME",
    payload: isFirstTime,
  };
}

export function setMachineState(machineState: ConfigurationState): Actions {
  return {
    type: "SET_MACHINE_STATE",
    payload: machineState,
  };
}

export function setIsInProgress(
  isInProgress: ConfigurationState["isInProgress"]
): Actions {
  return {
    type: "SET_IS_IN_PROGRESS",
    payload: isInProgress,
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
) {
  return (dispatch: any) => {
    dispatch(setActionPending(undefined));
    dispatch({
      type: "SET_FAILURE_RESPONSE_STATUS",
      payload: {
        responseMessage,
        responseStatus: "failure",
      },
    });
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
  payload: Omit<ConfigurationState, "responseMessage" | "responseStatus">
): Actions {
  return {
    type: "SET_STEP_AND_ACTION_STATUS",
    payload,
  };
}

export function setVariables(payload: SetVariableAction["payload"]): Actions {
  return {
    type: "SET_VARIABLES",
    payload,
  };
}

export function deleteConfig(history: any) {
  return (dispatch: any) => {
    dispatch(setActionPending(1));
    getApiResponse<DeleteConfigResponse>({
      urlName: "delete_config",
    })
      .then(({ data: { message } }) => {
        dispatch(setSuccessResponseStatus(message));
        dispatch(setStep(history));
      })
      .catch(() => {
        dispatch(setFailureResponseStatus());
      });
  };
}

export function setStep(history: any) {
  return (dispatch: any, getState: () => AppState) => {
    const {
      configuration: { actionPending },
    } = getState();
    getApiResponse<GetStepResponse>({ urlName: "get_status" })
      .then((response) => {
        const {
          data: { data },
        } = response;

        if (response?.status === 206) {
          dispatch(setIsInProgress(true));
        }

        if (Object.keys(data).length && response.status !== 206) {
          const stepNo =
            data.status === "success" && data.state < 8
              ? data.state + 1
              : data.state;
          const step = stepNo === 0 ? 1 : stepNo;

          if (actionPending && data.status === "success") {
            redirectToNextPage(
              data?.processedData,
              history,
              step,
              actionPending
            );
            dispatch(setActionPending(undefined));
          }

          dispatch(
            setStepAndActionStatus({
              step,
              isInProgress: data.status === "in-progress",
              error: data.error,
              progress: data.progress,
              processedData: data.processedData,
              controllerIP: data.controllerIP,
              isFirstTime: false,
              ips: data.ips,
              is_advance: data.is_advance,
            })
          );

          if (data.status === "failed") {
            dispatch(
              setFailureResponseStatus(
                "An error occurred. See Debug info for more details."
              )
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

/**
 * Step 1: send Api call
 * Step 2: set step with logic
 * Step 3a: If state is in progess, land to that page, avake actionPending variable
 * Step 3b: If state is not in progress, check if we have "no" values in page 3,4 and 6, Land to them if any
 * @param history
 */
export function initialization(history: any) {
  return (dispatch: any) => {
    getApiResponse<GetStepResponse>({ urlName: "get_status" })
      .then((response) => {
        const {
          data: { data },
        } = response;

        if (response?.status === 206) {
          dispatch(setIsInProgress(true));
        }

        if (Object.keys(data).length && response.status !== 206) {
          const stepNo =
            data.status === "success" && data.state < 8
              ? data.state + 1
              : data.state;
          const step = stepNo === 0 ? 1 : stepNo;
          const commonParameters = {
            step,
            isInProgress: data.status === "in-progress",
            error: data.error,
            progress: data.progress,
            processedData: data.processedData,
            controllerIP: data.controllerIP,
            isFirstTime: false,
            ips: data.ips,
            is_advance: data.is_advance,
          };
          if (data.status === "in-progress") {
            history.push(getRoute(`${ROUTES.configuration}/${step}`));
            dispatch(
              setStepAndActionStatus({
                ...commonParameters,
                actionPending: step,
              })
            );
          } else {
            const nextPage = getCurrentPageNo(data?.processedData, step);

            history.push(getRoute(`${ROUTES.configuration}/${nextPage}`));
            dispatch(setStepAndActionStatus(commonParameters));
          }

          if (data.status === "failed") {
            dispatch(
              setFailureResponseStatus(
                "An error occurred. See Debug info for more details."
              )
            );
          }
        }
      })
      .catch((error) => {
        if (error?.response?.data?.message !== "No record found") {
          dispatch(setFailureResponseStatus(error?.response?.data?.message));
        }
      })
      .finally(() => {
        dispatch(setIsFirstTime(false));
      });
  };
}

export function addAWSCredentials(
  data: {
    key_id: string;
    secret_key: string;
  },
  history: any
) {
  return (dispatch: any) => {
    dispatch(setActionPending(1));
    getApiResponse<AddAWSCredentialsResponse>({
      urlName: "add_credentials",
      data,
    })
      .then(({ data: { message } }) => {
        dispatch(setSuccessResponseStatus(message));
        dispatch(setStep(history));
      })
      .catch(() => {
        dispatch(setFailureResponseStatus());
      });
  };
}

export function launchController(data: ControllerPayload, history: any) {
  return (dispatch: any) => {
    dispatch(setActionPending(2));
    getApiResponse<any>({
      urlName: "launch_controller",
      data,
    })
      .then(({ data }) => {
        dispatch(setSuccessResponseStatus(data?.message));
        dispatch(setStep(history));
      })
      .catch(() => {
        dispatch(setFailureResponseStatus());
      });
  };
}

export function launchTransit(data: { command: boolean }, history: any) {
  return (dispatch: any) => {
    dispatch(setActionPending(3));
    getApiResponse<any>({
      urlName: "launch_transit_aws",
      data,
    })
      .then(({ data }) => {
        dispatch(setSuccessResponseStatus(data?.message));
        dispatch(setStep(history));
      })
      .catch(() => {
        dispatch(setFailureResponseStatus());
      });
  };
}

export function launchEC2(data: { command: boolean }, history: any) {
  return (dispatch: any) => {
    dispatch(setActionPending(4));
    getApiResponse<any>({
      urlName: "launch_ec2",
      data,
    })
      .then(({ data }) => {
        dispatch(setSuccessResponseStatus(data?.message));
        dispatch(setStep(history));
      })
      .catch(() => {
        dispatch(setFailureResponseStatus());
      });
  };
}

export function launchSpokevpc(data: { keyname: string }, history: any) {
  return (dispatch: any) => {
    dispatch(setActionPending(5));
    getApiResponse<any>({
      urlName: "launch_spokevpc",
      data,
    })
      .then(({ data }) => {
        dispatch(setSuccessResponseStatus(data?.message));
        dispatch(setStep(history));
      })
      .catch(() => {
        dispatch(setFailureResponseStatus());
      });
  };
}

export function launchTransitAzure(
  data: {
    azure_subscription_id: string;
    azure_directory_id: string;
    azure_application_id: string;
    azure_application_key: string;
  },
  history: any
) {
  return (dispatch: any) => {
    dispatch(setActionPending(6));
    getApiResponse<any>({
      urlName: "launch_transit_azure",
      data,
    })
      .then(({ data }) => {
        dispatch(setSuccessResponseStatus(data?.message));
        dispatch(setStep(history));
      })
      .catch(() => {
        dispatch(setFailureResponseStatus());
      });
  };
}

export function skipTransitAzure(data: { command: boolean }, history: any) {
  return (dispatch: any) => {
    dispatch(setActionPending(6));
    getApiResponse<any>({
      urlName: "skip_transit_azure",
      data,
    })
      .then(({ data }) => {
        dispatch(setSuccessResponseStatus(data?.message));
        dispatch(setStep(history));
      })
      .catch(() => {
        dispatch(setFailureResponseStatus());
      });
  };
}

export function builtTransit(data: { command: boolean }, history: any) {
  return (dispatch: any) => {
    dispatch(setActionPending(7));
    getApiResponse<any>({
      urlName: "built_transit",
      data,
    })
      .then(({ data }) => {
        dispatch(setSuccessResponseStatus(data?.message));
        dispatch(setStep(history));
      })
      .catch(() => {
        dispatch(setFailureResponseStatus());
      });
  };
}

export function setIsAdvance(data: { is_advance: boolean }, history: any) {
  return (dispatch: any) => {
    getApiResponse<any>({
      urlName: "set_is_advance",
      data,
    })
      .then(() => {
        dispatch(setStep(history));
      })
      .catch(() => {
        dispatch(setFailureResponseStatus());
      });
  };
}

export function sendVariableCall(
  urlName: keyof Pick<
    UrlConfigs,
    "step2_variables" | "step3_variables" | "step6_variables"
  >,
  history: any
) {
  return (dispatch: any) => {
    getApiResponse<Step2Variables | Step3Variables | Step6Variables>({
      urlName,
    })
      .then(({ data: { data } }) => {
        dispatch(
          setVariables({
            [urlName]: data,
          } as any)
        );
        dispatch(setStep(history));
      })
      .catch(() => {
        dispatch(setFailureResponseStatus());
      });
  };
}
