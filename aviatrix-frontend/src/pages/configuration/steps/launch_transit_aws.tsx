import React, { useCallback } from "react";
import { useDispatch } from "react-redux";

import { setMachineState } from "store/actions/configuration";
import { Button, Heading, Paragraph } from "components/base";

export default function LaunchTransitAWS() {
  const dispatch = useDispatch();
  const onSubmit = useCallback(() => {
    dispatch(setMachineState({ step: 4, isInProgress: false }));
  }, [dispatch]);

  return (
    <div className="launch-transit-aws-grid">
      <div className="text-block">
        <Heading
          customClasses="--dark"
          text="Launch Aviatrix Transit in AWS"
        ></Heading>
        <Paragraph
          customClasses="--light"
          text="Built in US-EAST 2 region which is Ohio"
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
