import React from "react";
import { CustomClasses } from "types";

interface ComponentProps extends CustomClasses {
  text: string;
}

export default function Heading({ text, customClasses = "" }: ComponentProps) {
  return <label className={`heading ${customClasses}`}>{text}</label>;
}
