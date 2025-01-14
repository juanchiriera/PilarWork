import { Admin, Resource} from 'react-admin';
import { Layout } from './Layout';
import { dataProvider } from './dataProvider';
import EspaciosList from './pages/espacios/espacios-list';
import EspacioShow from './pages/espacios/espacio-show';


export const App = () => (
   <Admin layout={Layout} dataProvider={dataProvider}>
        <Resource name="espacios" list={EspaciosList} show= {EspacioShow}/>
    </Admin>
);

    