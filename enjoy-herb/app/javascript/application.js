import { Runtime } from "reactionview"

// Keep the request debounce below Fragment's delay so fast reads do not flash.
window.HerbRuntime = Runtime.start({ state: { debounce: 200, refetchDebounce: 50 } })
