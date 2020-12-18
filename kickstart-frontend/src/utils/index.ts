import { useEffect, useRef } from "react";
import axios from "axios";

import { UrlNames } from "types/api";
import { ConfigurationState } from "types/store";
import { ROUTES, URL_CONFIGS } from "./constants";

export const classNames = (classesObj: Object) => {
  const classes = Object.entries(classesObj).map(([key, value]) =>
    Boolean(value) ? key : undefined
  );
  return classes.filter((cls) => Boolean(cls)).join(" ");
};

export function getRoute(pathname: string) {
  return { pathname, state: { fromApp: true } };
}

export function getApiResponse<ResponseType>(props: {
  urlName: UrlNames;
  data?: object;
  headers?: object;
  parameter?: string;
}) {
  const { urlName, data, headers, parameter = "" } = props;
  const { url, headers: staticHeaders, data: staticData, method } = URL_CONFIGS[
    urlName
  ];
  const updatedUrl =
    process.env.NODE_ENV === "development" ? url : `/api/v1.0${url}`;
  return axios.request<ResponseType>({
    method,
    url: updatedUrl + parameter,
    headers: headers || staticHeaders,
    data: data || staticData,
  });
}

export function useCustomPolling(
  callback: any,
  delay: number,
  dependencies: any[]
) {
  const savedCallback: React.MutableRefObject<undefined | any> = useRef();

  // Remember the latest callback.
  useEffect(() => {
    savedCallback.current = callback;
  }, [callback]);

  // Set up the interval.
  useEffect(() => {
    function tick() {
      savedCallback.current();
    }
    if (delay !== null) {
      tick();
      const id = setInterval(tick, delay);
      return () => clearInterval(id);
    }
  }, [delay, ...dependencies]);
}

export function copyToClipboard(text: string, elementId: string) {
  const textField = document.createElement("textarea");
  textField.innerText = text;
  const parentElement = document.getElementById(elementId);
  parentElement?.appendChild(textField);
  textField.select();
  document.execCommand("copy");
  parentElement?.removeChild(textField);
}

export function redirectToNextPage(
  data: ConfigurationState["processedData"] = {},
  history: any[],
  step: number,
  actionPendingPageNo?: number
) {
  switch (actionPendingPageNo) {
    case 3:
      if (data?.ec2SpokeVpc?.state === "no") {
        history.push(getRoute(`${ROUTES.configuration}/${4}`));
      } else if (data?.avaitrixTransitAzure?.state === "no") {
        history.push(getRoute(`${ROUTES.configuration}/${6}`));
      } else if (data?.peering?.state === "no") {
        history.push(getRoute(`${ROUTES.configuration}/${7}`));
      } else {
        history.push(getRoute(`${ROUTES.configuration}/${step}`));
      }
      break;
    case 4:
      if (data?.ec2SpokeVpc?.state === null) {
        history.push(getRoute(`${ROUTES.configuration}/${5}`));
      } else if (data?.avaitrixTransitAzure?.state === "no") {
        history.push(getRoute(`${ROUTES.configuration}/${6}`));
      } else if (data?.peering?.state === "no") {
        history.push(getRoute(`${ROUTES.configuration}/${7}`));
      } else {
        history.push(getRoute(`${ROUTES.configuration}/${step}`));
      }
      break;
    case 5:
      if (data?.avaitrixTransitAzure?.state === "no") {
        history.push(getRoute(`${ROUTES.configuration}/${6}`));
      } else if (data?.peering?.state === "no") {
        history.push(getRoute(`${ROUTES.configuration}/${7}`));
      } else {
        history.push(getRoute(`${ROUTES.configuration}/${step}`));
      }
      break;
    case 6:
      if (data?.avaitrixTransitAzure?.state === "yes") {
        history.push(getRoute(`${ROUTES.configuration}/${7}`));
      } else {
        history.push(getRoute(`${ROUTES.configuration}/${step}`));
      }
      break;
    default:
      history.push(getRoute(`${ROUTES.configuration}/${step}`));
      break;
  }
}

export function getCurrentPageNo(
  data: ConfigurationState["processedData"] = {},
  step: number
) {
  if (data?.launchAviatrixTransit?.state === "no") {
    return 3;
  } else if (data?.ec2SpokeVpc?.state === "no") {
    return 4;
  } else if (data?.avaitrixTransitAzure?.state === "no") {
    return 6;
  } else if (data?.peering?.state === "no") {
    return 7;
  } else {
    return step;
  }
}
