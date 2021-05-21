import React from "react";
import { useSelector } from "react-redux";

import { AppState } from "store";

import StepNumber from "./step-number";

interface ComponentProps {
  stepNo: number;
}

const stepsList = [
  "Add AWS Credentials",
  "Launch Controller",
  "Launch Aviatrix Transit in AWS",
  "Launch EC2 instances in the AWS Spoke VPCs",
  "Key Pair Name",
  "Launch Aviatrix Transit in Azure",
  "Build Transit Peering between AWS & Azure",
];

export default function StepsAside(props: ComponentProps) {
  const { stepNo } = props;
  const {
    step: currentStep,
    processedData: {
      launchAviatrixTransit,
      ec2SpokeVpc,
      avaitrixTransitAzure,
      peering,
    } = {},
  } = useSelector<AppState, AppState["configuration"]>(
    (state) => state.configuration
  );
  const skipForNow: { [key: number]: boolean } = {
    2: launchAviatrixTransit?.state === "no",
    3: ec2SpokeVpc?.state === "no",
    4: ec2SpokeVpc?.state === "no",
    5: avaitrixTransitAzure?.state === "no",
    6: avaitrixTransitAzure?.state === "no" || peering?.state === "no",
  };

  return (
    <ul className="steps-list">
      {stepsList.map((step, index) => (
        <li className="step-item" key={step}>
          <StepNumber
            text={step}
            stepNo={index + 1}
            currentStep={currentStep}
            disabled={stepNo !== index + 1}
            isViewedStep={currentStep > index + 1}
            skipForNow={skipForNow[index]}
          />
        </li>
      ))}
    </ul>
  );
}
