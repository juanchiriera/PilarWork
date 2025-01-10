
import { Admin, Resource} from 'react-admin';
import { Layout } from './Layout';
import { dataProvider } from './dataProvider';
import EspaciosList from './pages/espacios/espacios-list';


export const App = () => (
    <Admin
        layout={Layout}
        dataProvider={dataProvider}
	>
         <Resource name="espacio" list={EspaciosList} />
        
    </Admin>
);

    