import React from "react";
import { checkIcon } from "svgs";

import { Heading } from "components/base";
import { classNames } from "utils";

interface ComponentProps {
  value: string;
  disabled?: boolean;
  isViewedStep?: boolean;
  skipForNow?: boolean;
  onClick?: () => void;
}

export default function StepCircle(props: ComponentProps) {
  const { value, disabled, isViewedStep, skipForNow = false, onClick } = props;
  const outerClasses = classNames({
    "outer-circle": true,
    "--disabled": disabled,
    "--transparent": isViewedStep,
  });

  return (
    <div
      role="button"
      className={outerClasses}
      skip-for-now={skipForNow.toString()}
      onClick={onClick}
    >
      <div className="inner-circle">
        {isViewedStep ? (
          checkIcon
        ) : (
          <Heading text={value} customClasses="--inverse" />
        )}
      </div>
    </div>
  );
}
