import { Admin, Resource} from 'react-admin';
import { Layout } from './Layout';
import { dataProvider } from './dataProvider';
import espaciosList from './pages/espacios/espacios-list';
import espacioShow from './pages/espacios/espacio-show';
import espacioEdit from './pages/espacios/espacio-edit';
import espacioCreate from './pages/espacios/espacio-create';
import clientesList from './pages/clientes/clientes-list';
import clientesShow from './pages/clientes/clientes-show';
import clienteEdit from './pages/clientes/clientes-edit';
import clienteCreate from './pages/clientes/clientes-create'
import elementosList from './pages/elementos/elementos-list';
import elementoEdit from './pages/elementos/elemento-edit';
import elementosShow from './pages/elementos/elemento-show';


export const App = () => (
   <Admin layout={Layout} dataProvider={dataProvider}>
        <Resource name="espacios" list={espaciosList} show= {espacioShow} edit= {espacioEdit} create={espacioCreate}/>
        <Resource name="clientes" list={clientesList} show={clientesShow} edit={clienteEdit} create={clienteCreate}/>
        <Resource name="elementos" list={elementosList} edit={elementoEdit} show={elementosShow}/>
    </Admin>
);

    