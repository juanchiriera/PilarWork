import { Admin, Resource} from 'react-admin';
import { Layout } from './Layout';
import { dataProvider } from './dataProvider';
import espaciosList from './pages/espacios/espacios-list';
import espacioShow from './pages/espacios/espacio-show';
import espacioEdit from './pages/espacios/espacio-edit';
import espacioCreate from './pages/espacios/espacio-create';



export const App = () => (
   <Admin layout={Layout} dataProvider={dataProvider}>
        <Resource name="espacios" list={espaciosList} show= {espacioShow} edit= {espacioEdit} create={espacioCreate}/>
    </Admin>
);

    