import React from "react";

import StepNumber from "./step-number";

interface ComponentProps {
  stepNo: number;
}

const stepsList = [
  "Add AWS Credentials",
  "Launch Controller",
  "Launch Aviatrix Transit in AWS",
  "Launch EC2 instances in the AWS Spoke VPCs",
  "Import Key Pair",
  "Launch Aviatrix Transit in Azure",
  "Built Transit Peering between AWS & Azure",
];

export default function StepsAside(props: ComponentProps) {
  const { stepNo } = props;

  return (
    <ul className="steps-list">
      {stepsList.map((step, index) => (
        <li className="step-item" key={step}>
          <StepNumber
            text={step}
            stepNo={index + 1}
            disabled={stepNo !== index + 1}
            isViewedStep={stepNo > index + 1}
          />
        </li>
      ))}
    </ul>
  );
}
