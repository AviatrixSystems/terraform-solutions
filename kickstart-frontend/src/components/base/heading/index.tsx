import React, { ReactNode } from "react";
import { CustomClasses } from "types";

interface ComponentProps extends CustomClasses {
  text: ReactNode;
}

export default function Heading({ text, customClasses = "" }: ComponentProps) {
  return <label className={`heading ${customClasses}`}>{text}</label>;
}
