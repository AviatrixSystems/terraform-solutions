import React from "react";

import { Heading } from "components/base";
import Logo from "../../images/logo.png";

export default function AppBar() {
  return (
    <header className="app-header">
      <img className="app-logo__logo" src={Logo} alt="Aviatrix logo" />
      <div className="app-logo__divider" />
      <Heading text="KICKSTART" customClasses="--title" />
    </header>
  );
}
