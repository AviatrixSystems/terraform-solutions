import React, { useCallback } from "react";
import { useDispatch } from "react-redux";

import { Button, Heading } from "components/base";
import Logo from "../../images/logo.png";
import { deleteConfig } from "store/actions";
import { helpIcon, reloadIcon } from "svgs";

export default function AppBar() {
  const dispatch = useDispatch();

  const onDelete = useCallback(() => {
    const response = window.confirm("Are you sure you want to destroy?");
    if (response) {
      dispatch(deleteConfig());
    }
  }, [dispatch]);

  return (
    <header className="app-header">
      <img className="app-logo__logo" src={Logo} alt="Aviatrix logo" />
      <div className="app-logo__divider" />
      <Heading text="KICKSTART" customClasses="--title" />
      <a className="mailto" href="mailto:kickstart@aviatrix.com">
        {helpIcon}
      </a>
      <Button
        title="Terraform Destroy"
        variant="contained"
        customClasses="--primary-inverse"
        onClick={onDelete}
        startIcon={reloadIcon}
      >
        Destroy
      </Button>
    </header>
  );
}
