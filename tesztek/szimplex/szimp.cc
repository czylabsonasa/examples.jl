template< typename T > T Gcd( T a , T b )
{
	T r ;
	do
	{
		r = a % b ;
		a = b ; 
		b = r ;
	}
	while( b ) ; 

	return( a ) ;
}
template< typename T > inline T Abs( T a ) { return ( ( a < 0 ) ? -a : a ) ; }
template< typename T > inline T Min( T a , T b ) { return ( ( a < b ) ? a : b ) ; }
template< typename T > inline T Max( T a , T b ) { return ( ( a > b ) ? a : b ) ; }
template< typename T > inline void Swap( T& a , T& b ) { T _s = a ; a = b ; b = _s ; ; }


#include <stdio.h>
#define GETCHAR getchar
#define DIG( x ) ( ( ( x ) >= '0' ) && ( ( x ) <= '9' ) )
template < typename T > inline bool Olvas( T & x ) 
{
	int c ; 
	do
	{
   	c = GETCHAR() ;
	}
	while( ( c != EOF ) && ( c != '-' ) && ! DIG( c ) ) ;

	if( c == EOF )
		return false ;
	
	bool neg = false ;
	if( c == '-' )
	{
		neg = true ;
		c = GETCHAR() ;	
	}

	x = 0 ;
	do
	{
		x = 10 * x + ( T ) ( c - '0' ) ;
   	c = GETCHAR() ;
	}
	while( DIG( c ) ) ;
	if( neg ) 
		x = -x ;
	return true ;
}


template < typename T > inline bool Olvas( char*& ebbol , T& x ) 
{
	int c ; 
	while( 1 )
	{
   	c = ( * ebbol ) ;
		if( !c || ( c == '-' ) || DIG( c ) )
			break ;
		ebbol ++ ;	
	}

	if( !c )
		return false ;
	
	bool neg = false ;
	if( c == '-' )
	{
		neg = true ;
		c = ( * ( ++ ebbol ) ) ; 	
	}

	x = 0 ;
	while( DIG( c ) )
	{
		x = 10 * x + ( T ) ( c - '0' ) ;
   	c = ( * ( ++ ebbol ) ) ;
	}

	if( neg ) 
		x = -x ;
	return true ;
}





#include <string.h>
namespace
{

	// esetleg template
/*
	typedef long long int RT ;
	const char FS1[] = "%Ld" ;
	const char FS2[] = "%Ld/%Ld" ;
*/
	typedef int RT ;
	const char FS1[] = "%d" ;
	const char FS2[] = "%d/%d" ;

	void Ir( char* ebbe , int ezt )
	{
		sprintf( ebbe , FS1 , ezt ) ;
	}


	struct Rac
	{
		RT a ;
		RT b ;
		Rac() : a( 0 ) , b( 1 )
		{}
		Rac( RT _a , RT _b ) : a( _a ) , b( _b )
		{}
		Rac( RT _a ) : a( _a ) , b( 1 )
		{}
		Rac( const Rac& masik ) : a( masik.a ) , b( masik.b ) 
		{}
		void Set( const RT _a , const RT _b )
		{
			a = _a ; b = _b ;
		}
		void Set( const RT _a )
		{
			a = _a ; b = 1 ;
		}
		bool Egyszerusit()
		{
			if( !b )
				return false ;
			if( !a )
			{
				b = 1 ;
				return true ;
			}
			if( b < 0 )
			{
				a = -a ;
				b = -b ;
			}
			RT d = Gcd( Abs( a ) , b ) ;
			a /= d ;
			b /= d ;
			return true ;
		}
		
		// osszeadas
		Rac operator+( const RT& masik ) const 
		{
			Rac tmp( a + b * masik , b ) ;
			tmp.Egyszerusit() ;
			return tmp ;
		}

		Rac operator+( const Rac& masik ) const 
		{
			Rac tmp( a * masik.b + b * masik.a , b * masik.b ) ;
			tmp.Egyszerusit() ;
			return tmp ;
		}
		Rac& operator+=( const RT& masik )
		{
			a = a + b * masik ;
			this -> Egyszerusit() ;
			return *this ;
		}

		Rac& operator+=( const Rac& masik )
		{
			a = a * masik.b + b * masik.a ;
			b *= masik.b ;
			this -> Egyszerusit() ;
			return *this ;
		}
		// osszeadas

		// szorzas
		Rac operator*( const RT& masik ) const 
		{
			Rac tmp( a * masik , b ) ;
			tmp.Egyszerusit() ;
			return tmp ;
		}
		Rac operator*=( const RT& masik )
		{
			a *= masik ;
			this->Egyszerusit() ;
			return *this ;
		}

		Rac operator*( const Rac& masik ) const 
		{
			Rac tmp( a * masik.a , b * masik.b ) ;
			tmp.Egyszerusit() ;
			return tmp ;
		}
		Rac operator*=( const Rac& masik )  
		{
			a *= masik.a ; 
			b *= masik.b ;
			this->Egyszerusit() ;
			return *this ;
		}
		// szorzas

		// kivonas
		Rac operator-( const RT& masik ) const 
		{
			Rac tmp( a - b * masik , b ) ;
			tmp.Egyszerusit() ;
			return tmp ;
		}

		Rac operator-( const Rac& masik ) const 
		{
			Rac tmp( a * masik.b - b * masik.a , b * masik.b ) ;
			tmp.Egyszerusit() ;
			return tmp ;
		}
		Rac& operator-=( const RT& masik )
		{
			a = a - b * masik ;
			this -> Egyszerusit() ;
			return *this ;
		}

		Rac& operator-=( const Rac& masik )
		{
			a = a * masik.b - b * masik.a ;
			b *= masik.b ;
			this -> Egyszerusit() ;
			return *this ;
		}
		// kivonas



		// osztas
		Rac operator/( const RT& masik ) const 
		{
			Rac tmp( a , masik * b ) ;
			tmp.Egyszerusit() ;
			return tmp ;
		}
		Rac operator/=( const RT& masik )
		{
			b *= masik ;
			this->Egyszerusit() ;
			return *this ;
		}

		Rac operator/( const Rac& masik ) const 
		{
			Rac tmp( a * masik.b , b * masik.a ) ;
			tmp.Egyszerusit() ;
			return tmp ;
		}
		Rac operator/=( const Rac& masik )  
		{
			a *= masik.b ; 
			b *= masik.a ;
			this->Egyszerusit() ;
			return *this ;
		}
		// osztas

		// =
		Rac& operator=( const Rac& masik )
		{
			a = masik.a ;
			b = masik.b ;
			return *this ;
		}
		Rac& operator=( const RT& masik )
		{
			a = masik ;
			b = 1 ;
			return *this ;
		}
		// =

		

		void Ir()
		{
			if( b != 1 )
			{
				printf( FS2 , a , b ) ;
			}
			else
				printf( FS1 , a ) ;
			printf( "\n" ) ;
		}

		void Ir( char* ebbe )
		{
			if( b != 1 )
				sprintf( ebbe , FS2 , a , b ) ;
			else
				sprintf( ebbe , FS1 , a ) ;
		}


		
		void Olvas( char*& ebbol ) 
		{
			::Olvas( ebbol , a ) ;
			if( ( *ebbol ) == '/' )
				::Olvas( ebbol , b ) ;
			else
				b = 1 ;
			this->Egyszerusit() ;
		}
	} ; // struct Rac

	struct Tabla
	{
		const int KF ;
		const int VALT ;
		const int B ;
		int kfsz ; // korlatozo feltetelek szama
		int vsz ; // valtozok szama
		char* benn ;
		int nkinn ;
		int* loc ;
		int* blista ;
		int* klista ;
		Rac* c ;
		Rac** tabla ;
		Rac** ntabla ;
		char* buff ;
		char*** out ;
		int wmax ;

		Tabla( int _KF , int _VALT ) : KF( _KF ) , VALT( _VALT ) , B( 64 * 1024 )
		{
			benn = new char[ VALT ] ;
			loc = new int[ VALT ] ;
			blista = new int[ VALT ] ;
			klista = new int[ VALT ] ;

			c = new Rac[ VALT ] ;
			tabla = new Rac*[ KF ] ;
			for( int i = 0 ; i < KF ; tabla[ i ++ ] = new Rac[ VALT ] ) ;
			ntabla = new Rac*[ KF ] ;
			for( int i = 0 ; i < KF ; ntabla[ i ++ ] = new Rac[ VALT ] ) ;
			buff = new char[ B ] ;
			

			out = new char** [ VALT ] ;
			char* pout = buff ;
			for( int i = 0 ; i < VALT ; i ++ ) 
			{
				out[ i ] = new char*[ VALT ] ;
				for( int j = 0 ; j < VALT ; j ++ )
				{
					out[ i ][ j ] = pout ;
					pout += 128 ; // egy ad-hoc szelesseg
				}
			}
		}
		~Tabla()
		{
			delete[] benn ;
			delete[] loc ;
			delete[] blista ;
			delete[] klista ;
			delete[] c ;
			for( int i = 0 ; i < KF ; delete[] tabla[ i ++ ] ) ;
			delete[] tabla ;
			for( int i = 0 ; i < KF ; delete[] ntabla[ i ++ ] ) ;
			delete[] ntabla ;
			delete[] buff ;
			for( int i = 0 ; i < KF ; delete[] out[ i ++ ] ) ;
			delete[] out ;

		}
		
		void Olvas( FILE* fin )
		{
			// input file bufferbe:
			fread( buff , 1 , B , fin ) ;
			char* tb = buff ;

			
			// meretek:
			::Olvas( tb , kfsz ) ;
			::Olvas( tb , vsz ) ;
			
			
			// celfv:
			for( int i = 1 ; i <= vsz ; i ++ )
			{
				c[ i ].Olvas( tb ) ;
			}
			c[ 0 ] = 0 ;
			
			// benn:
			for( int i = 1 ; i <= vsz ; benn[ i ++ ] = 0 ) ;
			for( int i = 1 ; i <= kfsz ; i ++ )
			{
				int t ; ::Olvas( tb , t ) ; 
				blista[ i ] = t ;
				benn[ t ] = 1 ;
				loc[ t ] = i ;
				tabla[ i ][ 0 ].Set( RT( t ) , RT( 1 ) ) ;
			}
			
			// kinn:
			nkinn = vsz - kfsz ;
			for( int i = 1 ; i <= nkinn ; i ++ )
			{
				int t ; ::Olvas( tb , t ) ; 
				klista[ i ] = t ;
				loc[ t ] = i ;
				tabla[ 0 ][ i ].Set( RT( t ) , RT( 1 ) ) ;
			}
			klista[ nkinn + 1 ] = 0 ;
			c[ 0 ] = 0 ; 
			
			// beraktam az x-et az utolso oszlopba
			// tabla olvas:
			for( int i = 1 ; i <= kfsz ; i ++ )
			{
				for( int j = 1 ; j <= nkinn + 1 ; j ++ )
				{
					tabla[ i ][ j ].Olvas( tb ) ;
				}
			}

			for( int j = 1 ; j <= nkinn + 1 ; j ++ )
			{
				Rac zj( 0 ) ;
				for( int i = 1 ; i <= kfsz ; i ++ )
				{
					zj += c[ blista[ i ] ] * tabla[ i ][ j ] ;
				}
//				tabla[ kfsz + 1 ][ j ] = c[ klista[ j ] ] - zj ;
				tabla[ kfsz + 1 ][ j ] =  zj - c[ klista[ j ] ] ;
			}
		} // Olvas

		void Out()
		{
			char kicsi[ 128 ] ;
			// bal felso sarok
			sprintf( out[ 0 ][ 0 ] , " " ) ;

			// felso sor
			for( int j = 1 ; j <= nkinn ; j ++ )
			{
				::Ir( kicsi , klista[ j ] ) ;
				sprintf( out[ 0 ][ j ] , "[%s]" , kicsi ) ;
			}
			sprintf( out[ 0 ][ nkinn + 1 ] , "[x]" ) ;


			// mezok max szelessege:
			wmax = 0 ;
			for( int i = 1 ; i <= kfsz ; i ++ )
			{
				::Ir( kicsi , blista[ i ] ) ;
				sprintf( out[ i ][ 0 ] , "[%s]" , kicsi ) ;
				for( int j = 1 ; j <= nkinn + 1 ; j ++ )
				{
					tabla[ i ][ j ].Ir( out[ i ][ j ] ) ;
					int tmax = strlen( out[ i ][ j ] ) ;
					wmax = Max( tmax , wmax ) ;
				}
			}

			// also sor
			sprintf( out[ kfsz + 1 ][ 0 ] , " " ) ; // bal also 
			for( int j = 1 ; j <= nkinn + 1 ; j ++ )
			{
				tabla[ kfsz + 1 ][ j ].Ir( out[ kfsz + 1  ][ j ] ) ;
				int tmax = strlen( out[ kfsz + 1  ][ j ] ) ;
				wmax = Max( tmax , wmax ) ;
			}

			wmax += 2 ;
			wmax = Max( 4 , wmax ) ;
		}
		void Ir( FILE* fout )
		{
			fprintf( fout , "%s" , "\n" ) ;
			fprintf( fout , "%*s" , wmax , "" ) ;
			for( int j = 1 ; j <= nkinn + 1 ; j ++ )
			{
				fprintf( fout , "%*s" , wmax , out[ 0 ][ j ] ) ;
			}
			fprintf( fout , "\n\n" ) ;
			
			for( int i = 1 ; i <= kfsz + 1 ; i ++ )
			{
				for( int j = 0 ; j <= nkinn + 1 ; j ++ )
				{
					fprintf( fout , "%*s" , wmax , out[ i ][ j ] ) ;
				}
				fprintf( fout , "\n" ) ;
			}
		}

		bool Cmd( int c1 , int c2 )
		{
			if( c1 < 1 || c1 > vsz || c2 < 1 || c2 > vsz )
				return false ;
			if( ( benn[ c1 ] + benn[ c2 ] ) != 1 )
				return false ;
			if( benn[ c2 ] )
			{
				Swap( c1 , c2 ) ;
			}
			int t1 = loc[ c1 ] ;
			int t2 = loc[ c2 ] ;
			benn[ c1 ] = 0 ;
			benn[ c2 ] = 1 ;
			blista[ t1 ] = c2 ;
			klista[ t2 ] = c1 ;
			

			loc[ c1 ] = t2 ;
			ntabla[ 0 ][ t2 ] = c1 ;
			loc[ c2 ] = t1 ;
			ntabla[ t1 ][ 0 ] = c2 ;
			
			
			// gen elem inverze
			Rac ginv( tabla[ t1 ][ t2 ].b , tabla[ t1 ][ t2 ].a ) ;
			ginv.Egyszerusit() ;
			// a helyén
			ntabla[ t1 ][ t2 ] = ginv ;

			// sorában
			for( int j = 1 ; j <= nkinn + 1 ; j ++ )
			{
				if( j == t2 )
					continue ;
				ntabla[ t1 ][ j ] = tabla[ t1 ][ j ] * ginv ; 
			}

			// oszlopában
			ginv *= RT( -1 ) ;
			for( int i = 1 ; i <= kfsz + 1 ; i ++ )
			{
				if( i == t1 )
					continue ;
				ntabla[ i ][ t2 ] = tabla[ i ][ t2 ] * ginv ; 
			}
			
			
			// máshol
			for( int i = 1 ; i <= kfsz + 1 ; i ++ )
			{
				if( i == t1 )
					continue ;
				for( int j = 1 ; j <= nkinn + 1 ; j ++ )
				{
					if( j == t2 )
						continue ;
					ntabla[ i ][ j ] = 
					tabla[ i ][ j ] + tabla[ t1 ][ j ] * tabla[ i ][ t2 ] * ginv ;
				}
			}
			
			Swap( tabla , ntabla ) ;
			
			return true ;
		}

	} ; // struct Tabla
	
}

int main( int npar , char** par )
{
	// korlfelt / valt szama:
	Tabla tbl( 32 , 32 ) ;
	
	// input fajlnev megadasa parancssorban:
	if( npar < 2 )
	{
		printf( "nem adtal meg feladatfájlt\n" ) ;
		return 1 ;
	}
	
	
	char in_name[ 64 ] , out_name[ 64 ] ;
	sprintf( in_name , "%s" , par[ 1 ] ) ; 
	sprintf( out_name , "%s.out" , in_name ) ; 
	FILE* fin = fopen( in_name , "r" ) ;
	FILE* fout = fopen( out_name , "w" ) ;
	
	
	
	
	// feladat fajl beolvas:
	tbl.Olvas( fin ) ;
	fclose( fin ) ;
		
	while( 1 )
	{
//		fprintf( fout , "---------------\n" ) ;
		tbl.Out() ;
		tbl.Ir( fout ) ;
		tbl.Ir( stdout ) ;
		printf( "\n-------> " ) ;
		int c1, c2 ; 
		Olvas( c1 ) ; 
		Olvas( c2 ) ;

		bool t( tbl.Cmd( c1 , c2 ) ) ;
		if( false == t )
			break ;
		fprintf( fout , "\n--------> swap: [%d] [%d]\n" , c1 , c2 ) ;
	}
	fprintf( fout , "\n--------> exiting\n" ) ;
	
	
	fclose( fout ) ;
	return 0 ;
}
