import React from "react";
import { checkIcon } from "svgs";

import { Heading } from "components/base";
import { classNames } from "utils";

interface ComponentProps {
  value: string;
  disabled?: boolean;
  isViewedStep?: boolean;
}

export default function StepCircle(props: ComponentProps) {
  const { value, disabled, isViewedStep } = props;
  const outerClasses = classNames({
    "outer-circle": true,
    "--disabled": disabled,
    "--transparent": isViewedStep,
  });

  return (
    <div className={outerClasses}>
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
