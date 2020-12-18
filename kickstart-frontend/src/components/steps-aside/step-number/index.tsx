import React, { useCallback } from "react";

import { Heading } from "components/base";
import StepCircle from "../step-circle";
import { classNames, getRoute } from "utils";
import { useHistory } from "react-router-dom";
import { ROUTES } from "utils/constants";

interface ComponentProps {
  text: string;
  stepNo: number;
  disabled?: boolean;
  isViewedStep?: boolean;
  skipForNow?: boolean;
  currentStep: number;
}

export default function StepNumber(props: ComponentProps) {
  const {
    text,
    stepNo,
    disabled,
    isViewedStep,
    skipForNow,
    currentStep,
  } = props;
  const history = useHistory();
  const clickableSteps = currentStep >= stepNo;
  const rowClasses = classNames({
    "step-row": true,
    "disabled-row": !clickableSteps,
  });
  const headingClasses = classNames({
    "--dark": !disabled,
    "--disabled": disabled,
  });
  const onStepClick = useCallback(() => {
    if (stepNo && currentStep >= stepNo) {
      history.push(getRoute(`${ROUTES.configuration}/${stepNo}`));
    }
  }, [stepNo, currentStep, history]);

  return (
    <div className={rowClasses}>
      <StepCircle
        value={stepNo.toString()}
        disabled={disabled}
        isViewedStep={isViewedStep || skipForNow}
        skipForNow={skipForNow}
        onClick={onStepClick}
      />
      <Heading
        text={<label onClick={onStepClick}>{text}</label>}
        customClasses={headingClasses}
      />
    </div>
  );
}
