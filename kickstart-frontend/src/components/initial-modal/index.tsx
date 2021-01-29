import React, { useCallback, useState } from "react";
import { Modal } from "@material-ui/core";
import { useHistory } from "react-router-dom";
import { useDispatch, useSelector } from "react-redux";

import { Heading, Paragraph } from "components/base";
import { Switch, Button } from "components/base";
import { closeIcon } from "svgs";
import { AppState } from "store";
import { setIsAdvance } from "store/actions";

export default function InitialModal() {
  const history = useHistory();
  const dispatch = useDispatch();
  const [switchBool, setSwitchBool] = useState(false);
  const { is_advance } = useSelector<AppState, AppState["configuration"]>(
    (state) => state.configuration
  );
  const onStandard = useCallback(() => {
    dispatch(setIsAdvance({ is_advance: false }, history));
  }, [dispatch, history]);
  const onClickOk = useCallback(() => {
    dispatch(setIsAdvance({ is_advance: switchBool }, history));
  }, [switchBool, dispatch, history]);
  const switchCallback = useCallback((checked: boolean) => {
    setSwitchBool(checked);
  }, []);

  return (
    <Modal
      open={is_advance === undefined}
      onClose={onStandard}
      aria-labelledby="simple-modal-title"
      aria-describedby="simple-modal-description"
      className="initial-modal"
      disableBackdropClick
    >
      <div className="__body">
        <div className="modal-header">
          <Heading
            text="Aviatrix Sandbox Starter"
            customClasses="--extra-dark --light-black"
          />
          <span className="close-icon" onClick={onStandard}>
            {closeIcon}
          </span>
        </div>
        <Paragraph
          text="Welcome to Aviatrix Sandbox Starter. Please select the preferred
mode."
          customClasses="--light"
        />

        <Switch
          state={switchBool}
          callback={switchCallback}
          options={{ left: "Standard", right: "Advanced" }}
        />
        <div className="button-group">
          <Button
            variant="contained"
            customClasses="--blue"
            onClick={onClickOk}
          >
            Done
          </Button>
          <Button
            variant="outlined"
            customClasses="--blue"
            onClick={onStandard}
          >
            Cancel
          </Button>
        </div>
      </div>
    </Modal>
  );
}
