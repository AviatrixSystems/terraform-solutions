import { createStore, compose, applyMiddleware } from "redux";
import thunkMiddleware from "redux-thunk";

import rootReducer from "./reducers";

const middlewareEnhancer = applyMiddleware(thunkMiddleware);
const composedEnhancers = compose(middlewareEnhancer);

export type AppState = ReturnType<typeof rootReducer>;

export default function configureStore(initialState?: AppState) {
  return createStore(rootReducer, initialState, composedEnhancers);
}
