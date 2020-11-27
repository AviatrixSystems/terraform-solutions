import React from "react";
import { TextField as MaterialInput, TextFieldProps } from "@material-ui/core";
import { CustomClasses } from "types";

export default function Input(props: TextFieldProps & CustomClasses) {
  return (
    <MaterialInput
      {...props}
      className={`custom-input-style ${props.customClasses}`}
    />
  );
}
