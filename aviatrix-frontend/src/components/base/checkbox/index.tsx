import React from "react";
import { Checkbox, CheckboxProps } from "@material-ui/core";

import { CustomClasses } from "types";

export default function CheckBox(props: CheckboxProps & CustomClasses) {
  return (
    <Checkbox
      {...props}
      className={`custom-checkbox-style ${props.customClasses || ""}`}
    />
  );
}
