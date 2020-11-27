import React, { useCallback } from "react";
import { useDispatch } from "react-redux";

import { setMachineState } from "store/actions/configuration";
import { Button, Heading, Paragraph } from "components/base";

export default function LaunchEC2() {
  const dispatch = useDispatch();
  const onSubmit = useCallback(() => {
    dispatch(setMachineState({ step: 5, isInProgress: false }));
  }, [dispatch]);

  return (
    <div className="launch-ec2-grid">
      <div className="text-block">
        <Heading
          customClasses="--dark"
          text="Do you want to launch EC2 instances in the AWS Spoke VPCs?"
        ></Heading>
        <Paragraph
          customClasses="--light"
          text="Lorem Ipsum is simply dummy text of the printing and typesetting industry.
          Lorem Ipsum has been the industry's standard dummy text ever since the 1500s"
        ></Paragraph>
      </div>
      <span>
        <Button variant="contained" customClasses="--blue" onClick={onSubmit}>
          Yes
        </Button>
        <Button variant="outlined" customClasses="--blue" onClick={onSubmit}>
          No
        </Button>
      </span>
    </div>
  );
}
