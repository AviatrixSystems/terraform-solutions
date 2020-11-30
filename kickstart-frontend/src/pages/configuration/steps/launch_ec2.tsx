import React, { useCallback } from "react";
import { useDispatch } from "react-redux";

import { launchEC2 } from "store/actions/configuration";
import { Button, Heading, Paragraph } from "components/base";

export default function LaunchEC2() {
  const dispatch = useDispatch();
  const onSubmit = useCallback(() => {
    dispatch(launchEC2({ command: true }));
  }, [dispatch]);
  const onNoClick = useCallback(() => {
    dispatch(launchEC2({ command: false }));
  }, [dispatch]);

  return (
    <div className="launch-ec2-grid">
      <div className="text-block">
        <Heading
          customClasses="--dark"
          text="Launch EC2 instances in the AWS Spoke VPCs"
        ></Heading>
        <Paragraph
          customClasses="--light"
          text="Do you want to launch test EC2 instances in the AWS Spoke VPCs?"
        ></Paragraph>
      </div>
      <span>
        <Button variant="contained" customClasses="--blue" onClick={onSubmit}>
          Yes
        </Button>
        <Button variant="outlined" customClasses="--blue" onClick={onNoClick}>
          No
        </Button>
      </span>
    </div>
  );
}
