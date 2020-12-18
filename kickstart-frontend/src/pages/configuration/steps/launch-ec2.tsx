import React, { useCallback } from "react";
import { useDispatch, useSelector } from "react-redux";
import { useHistory } from "react-router-dom";

import { launchEC2 } from "store/actions/configuration";
import { Button, Heading, Paragraph } from "components/base";
import { AppState } from "store";

export default function LaunchEC2() {
  const dispatch = useDispatch();
  const history = useHistory();
  const { step, processedData: { ec2SpokeVpc } = {} } = useSelector<
    AppState,
    AppState["configuration"]
  >((state) => state.configuration);
  const onSubmit = useCallback(() => {
    dispatch(launchEC2({ command: true }, history));
  }, [dispatch, history]);
  const onNoClick = useCallback(() => {
    dispatch(launchEC2({ command: false }, history));
  }, [dispatch, history]);
  const pageDisabled = step > 4 && step !== 5 && ec2SpokeVpc?.state !== "no";
  return (
    <div className="launch-ec2-grid">
      <div className="text-block">
        <Heading
          customClasses="--dark"
          text="Do you want to launch test EC2 instances in the AWS Spoke VPCs?"
        ></Heading>
        <Paragraph
          customClasses="--light"
          text="Do you want to launch test EC2 instances in the AWS Spoke VPCs?"
        ></Paragraph>
      </div>
      <span>
        <Button
          disabled={pageDisabled}
          variant="contained"
          customClasses="--blue"
          onClick={onSubmit}
        >
          Yes
        </Button>
        <Button
          disabled={pageDisabled}
          variant="outlined"
          customClasses="--blue"
          onClick={onNoClick}
        >
          No
        </Button>
      </span>
    </div>
  );
}
