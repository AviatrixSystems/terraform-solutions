import React from "react";
import { Button as MaterialButton, ButtonProps } from "@material-ui/core";
import { CustomClasses } from "types";

export default function Button(props: ButtonProps & CustomClasses) {
  return (
    <MaterialButton
      {...props}
      className={`custom-button-style ${props.customClasses}`}
    >
      {props.children}
    </MaterialButton>
  );
}
