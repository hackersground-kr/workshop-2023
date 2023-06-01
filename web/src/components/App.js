import { BrowserRouter, Route, Routes } from 'react-router-dom';

import Main from './Main';
import Info from './Info';

function App() {
  return(
    <div className="App font-sans">

      <BrowserRouter>
        <Routes>
          <Route exact path="/" component={Main} element={<Main />}/>
          <Route exact path="/info" component={Info} element={<Info />}/>
        </Routes>
      </BrowserRouter>

    </div>
    
  );
}

export default App;
