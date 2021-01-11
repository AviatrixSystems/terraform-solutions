import React, { useCallback } from "react";
import { useDispatch } from "react-redux";

import { launchTransit } from "store/actions/configuration";
import { Button, Heading, Paragraph } from "components/base";

export default function LaunchTransitAWS() {
  const dispatch = useDispatch();
  const onYes = useCallback(() => {
    dispatch(launchTransit({ command: true }));
  }, [dispatch]);
  const onNo = useCallback(() => {
    dispatch(launchTransit({ command: false }));
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
          text={
            <span>
              Do you want to launch the Aviatrix transit in AWS? Region will be
              us-east-2. Go to{" "}
              <a href="https://raw.githubusercontent.com/AviatrixSystems/terraform-solutions/master/solutions/img/kickstart.png">
                https://raw.githubusercontent.com/AviatrixSystems/terraform-solutions/master/solutions/img/kickstart.png
              </a>{" "}
              to view what is going to be launched.
            </span>
          }
        ></Paragraph>
      </div>
      <span>
        <Button variant="contained" customClasses="--blue" onClick={onYes}>
          Yes
        </Button>
        <Button variant="outlined" customClasses="--blue" onClick={onNo}>
          No
        </Button>
      </span>
    </div>
  );
}
