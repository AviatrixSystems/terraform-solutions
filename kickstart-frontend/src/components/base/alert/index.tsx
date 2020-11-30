import React from "react";
import { Alert as MaterialAlert, AlertProps } from "@material-ui/lab";
import { CustomClasses } from "types";

export default function Alert(props: AlertProps & CustomClasses) {
  return (
    <MaterialAlert
      {...props}
      className={`custom-alert-style ${props.customClasses}`}
    >
      {props.children}
    </MaterialAlert>
  );
}
