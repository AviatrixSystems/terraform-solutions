import React from "react";

import { Heading } from "components/base";
import StepCircle from "../step-circle";
import { classNames } from "utils";

interface ComponentProps {
  text: string;
  stepNo: number;
  disabled?: boolean;
  isViewedStep?: boolean;
}

export default function StepNumber(props: ComponentProps) {
  const { text, stepNo, disabled, isViewedStep } = props;
  const headingClasses = classNames({
    "--dark": !disabled,
    "--disabled": disabled,
  });
  return (
    <div className="step-row">
      <Heading text={text} customClasses={headingClasses} />
      <StepCircle
        value={stepNo.toString()}
        disabled={disabled}
        isViewedStep={isViewedStep}
      />
    </div>
  );
}
