import React, { useCallback } from "react";
import { useDispatch, useSelector } from "react-redux";
import { useHistory } from "react-router-dom";

import { Button, Heading, Paragraph } from "components/base";
import { builtTransit } from "store/actions/configuration";
import { AppState } from "store";

export default function BuiltTransit() {
  const dispatch = useDispatch();
  const history = useHistory();
  const {
    step,
    processedData: { avaitrixTransitAzure, peering } = {},
  } = useSelector<AppState, AppState["configuration"]>(
    (state) => state.configuration
  );
  const onYes = useCallback(() => {
    dispatch(builtTransit({ command: true }, history));
  }, [dispatch, history]);
  const onNo = useCallback(() => {
    dispatch(builtTransit({ command: false }, history));
  }, [dispatch, history]);

  const pageDisabled =
    step > 7 &&
    (avaitrixTransitAzure?.state === "no" || peering?.state !== "no");

  return (
    <div className="built-transit-grid">
      <div className="text-block">
        <Heading
          customClasses="--dark"
          text="Build Transit Peering between AWS & Azure"
        ></Heading>
        <Paragraph
          customClasses="--light"
          text="Do you want to build a transit peering between AWS and Azure?"
        ></Paragraph>
      </div>
      <span>
        <Button
          disabled={pageDisabled}
          variant="contained"
          customClasses="--blue"
          onClick={onYes}
        >
          Yes
        </Button>
        <Button
          disabled={pageDisabled}
          variant="outlined"
          customClasses="--blue"
          onClick={onNo}
        >
          No
        </Button>
      </span>
    </div>
  );
}
