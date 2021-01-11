import React, { useCallback, useState } from "react";
import { Drawer as MaterialDrawer } from "@material-ui/core";
import { useSelector } from "react-redux";

import { AppState } from "store";
import { debugIcon, drawerCloseIcon } from "svgs";
import { Heading } from "components/base";

// const errors = [
//   " Error creating IAM Role aviatrix-role-app: EntityAlreadyExists: Role with name aviatrix-role-app already exists.\n\tstatus code: 409, request id: 22e2bcd8-7956-4e55-a525-461cb784f648\n\n\n\n",
//   " Error creating IAM policy aviatrix-assume-role-policy: EntityAlreadyExists: A policy called aviatrix-assume-role-policy already exists. Duplicate names are not allowed.\n\tstatus code: 409, request id: 228398c4-9b5f-4a9c-a3f0-171f2847bac0\n\n\n\n",
//   " Error creating IAM policy aviatrix-app-policy: EntityAlreadyExists: A policy called aviatrix-app-policy already exists. Duplicate names are not allowed.\n\tstatus code: 409, request id: 8344e517-a00f-4581-999e-3ac2b3c9245f\n\n\n\n",
//   " Error creating IAM Role aviatrix-role-ec2: EntityAlreadyExists: Role with name aviatrix-role-ec2 already exists.\n\tstatus code: 409, request id: 121c9fda-acf7-4a15-b7bf-1272f6b794e2\n\n\n\n",
//   " Error import KeyPair: InvalidKeyPair.Duplicate: The keypair 'avtx-ctrl-key' already exists.\n\tstatus code: 400, request id: 138da223-d6e7-48fe-89d6-07c61bea6cbf\n\n\n--> Controller launch failed, aborting.\n",
// ];

export default function Drawer() {
  const [isDrawer, setIsDrawer] = useState(false);
  const toggleDrawer = useCallback(() => {
    setIsDrawer((st) => !st);
  }, []);
  const { error: errors, progress } = useSelector<
    AppState,
    AppState["configuration"]
  >((state) => state.configuration);
  return (
    <>
      <MaterialDrawer
        classes={{ root: "custom-drawer-root", paper: "custom-drawer-paper" }}
        anchor={"right"}
        open={isDrawer}
      >
        <header className="paper-header">
          <Heading
            customClasses="--dark"
            text={
              <span className="__text">
                <span className="__icon">{debugIcon}</span>
                <span>Debug info</span>
              </span>
            }
          />
          <span role="button" className="__btn-close" onClick={toggleDrawer}>
            {drawerCloseIcon}
          </span>
        </header>
        <section className="paper-main">
          {progress && (
            <span key={progress}>
              <span>{progress}</span>
              <br />
            </span>
          )}
          {errors &&
            errors.map((error) => (
              <span className="error-log" key={error}>
                <span>{error}</span>
                <br />
              </span>
            ))}
        </section>
      </MaterialDrawer>
      <span
        title="Debug info"
        className="btn-floating-debug"
        onClick={toggleDrawer}
      >
        {debugIcon}
      </span>
    </>
  );
}
