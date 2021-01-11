import React from "react";
import Grid from "@material-ui/core/Grid";
import Typography from "@material-ui/core/Typography";
import { Paragraph } from "..";
import { classNames } from "utils";
import { AntSwitch } from "./style";

interface ComponentProps {
  state: boolean;
  options: {
    [key in "left" | "right"]: string;
  };
  callback?: (checked: boolean) => void;
}

export default function Switch(props: ComponentProps) {
  const { options, callback, state } = props;
  const handleChange = (event: any) => {
    callback && callback(event.target.checked);
  };
  const standardClasses = classNames({
    "--light": state,
    "--dark": !state,
  });
  const advanceClasses = classNames({
    "--light": !state,
    "--dark": state,
  });
  return (
    <Typography component="div">
      <Grid component="label" container alignItems="center" spacing={1}>
        <Grid item className="--light">
          <Paragraph text={options.left} customClasses={standardClasses} />
        </Grid>
        <Grid item>
          <AntSwitch checked={state} onChange={handleChange} />
        </Grid>
        <Grid item>
          <Paragraph text={options.right} customClasses={advanceClasses} />
        </Grid>
      </Grid>
    </Typography>
  );
}
