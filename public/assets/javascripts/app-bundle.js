var app, dependencies;

dependencies = ['ui.router', 'restangular', 'ngStorage', 'permission', 'permission.ui', 'ngFileUpload', 'toaster'];

app = angular.module('mediMeet', dependencies);

app.config(["$httpProvider", function($httpProvider) {
  $httpProvider.interceptors.push('tokenInterceptor');
  return $httpProvider.interceptors.push('responseInterceptor');
}]);

app.run(["User", "TokenContainer", "$rootScope", "$state", "$stateParams", "Rails", "$transitions", function(User, TokenContainer, $rootScope, $state, $stateParams, Rails, $transitions) {
  $rootScope.$state = $state;
  $rootScope.$stateParams = $stateParams;
  return $transitions.onBefore({}, function(transition) {
    $rootScope.lastState = transition.from();
    return $rootScope.lastStateParams = transition.params('from');
  });
}]);

var indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

angular.module('mediMeet').run(["$q", "PermRoleStore", "User", function($q, PermRoleStore, User) {
  PermRoleStore.defineRole('anonymous', function(stateParams) {
    if (User.isAuthenticated()) {
      return false;
    } else {
      return true;
    }
  });
  PermRoleStore.defineRole('user', function(stateParams) {
    var defer;
    defer = $q.defer();
    User.getRoles().then(function(roles) {
      if (!roles) {
        defer.reject();
      }
      if (indexOf.call(roles, 'user') >= 0) {
        return defer.resolve();
      } else {
        return defer.reject();
      }
    }, function() {
      return defer.reject();
    });
    return defer.promise;
  });
  PermRoleStore.defineRole('admin', function(stateParams) {
    var defer;
    defer = $q.defer();
    User.getRoles().then(function(roles) {
      if (!roles) {
        defer.reject();
      }
      if (indexOf.call(roles, 'admin') >= 0) {
        return defer.resolve();
      } else {
        return defer.reject();
      }
    }, function() {
      return defer.reject();
    });
    return defer.promise;
  });
  PermRoleStore.defineRole('student', function(stateParams) {
    var defer;
    defer = $q.defer();
    User.getRoles().then(function(roles) {
      if (!roles) {
        defer.reject();
      }
      if (indexOf.call(roles, 'student') >= 0) {
        return defer.resolve();
      } else {
        return defer.reject();
      }
    }, function() {
      return defer.reject();
    });
    return defer.promise;
  });
  PermRoleStore.defineRole('institute', function(stateParams) {
    var defer;
    defer = $q.defer();
    User.getRoles().then(function(roles) {
      if (!roles) {
        defer.reject();
      }
      if (indexOf.call(roles, 'institute') >= 0) {
        return defer.resolve();
      } else {
        return defer.reject();
      }
    }, function() {
      return defer.reject();
    });
    return defer.promise;
  });
  PermRoleStore.defineRole('startup', function(stateParams) {
    var defer;
    defer = $q.defer();
    User.getRoles().then(function(roles) {
      if (!roles) {
        defer.reject();
      }
      if (indexOf.call(roles, 'startup') >= 0) {
        return defer.resolve();
      } else {
        return defer.reject();
      }
    }, function() {
      return defer.reject();
    });
    return defer.promise;
  });
  return PermRoleStore.defineRole('company', function(stateParams) {
    var defer;
    defer = $q.defer();
    User.getRoles().then(function(roles) {
      if (!roles) {
        defer.reject();
      }
      if (indexOf.call(roles, 'company') >= 0) {
        return defer.resolve();
      } else {
        return defer.reject();
      }
    }, function() {
      return defer.reject();
    });
    return defer.promise;
  });
}]);

angular.module('mediMeet').config(["$stateProvider", "$urlRouterProvider", "$locationProvider", function($stateProvider, $urlRouterProvider, $locationProvider) {
  console.log("Configuring Routes.");
  $urlRouterProvider.otherwise(function($injector) {
    var $state;
    $state = $injector.get("$state");
    return $state.go('root.home');
  });
  $locationProvider.html5Mode(true);
  $locationProvider.hashPrefix('');
  return $stateProvider.state('root', {
    url: '',
    abstract: true,
    views: {
      'header@': {
        templateUrl: 'assets/views/common/nav.html',
        controller: 'NavCtrl',
        controllerAs: 'nav'
      },
      'footer@': {
        templateUrl: 'assets/views/common/footer.html'
      }
    },
    resolve: {
      identity: ["TokenContainer", "User", "$rootScope", function(TokenContainer, User, $rootScope) {
        if (TokenContainer.get()) {
          return User.retrieveUser().then(function(user) {
            User.user = user;
            console.log('User Retrieved from Token');
            return $rootScope.$broadcast('user:stateChanged');
          });
        }
      }]
    }
  }).state('root.home', {
    url: '/',
    views: {
      'body@': {
        templateUrl: 'assets/views/common/home.html',
        controller: 'HomeCtrl',
        controllerAs: 'home'
      }
    }
  }).state('root.explore', {
    url: '/explore',
    params: {
      category: null
    },
    views: {
      'body@': {
        templateUrl: 'assets/views/common/search.html',
        controller: 'SearchCtrl',
        controllerAs: 'search'
      }
    },
    resolve: {
      category: ["$stateParams", "$state", function($stateParams, $state) {
        if ($stateParams.category) {
          return $stateParams.category;
        }
      }],
      initials: ["Interests", "$stateParams", "$state", function(Interests, $stateParams, $state) {
        if (!$stateParams.category) {
          $state.go('root.home');
          return null;
        }
        return Interests.getByCategory($stateParams.category).then((function(_this) {
          return function(response) {
            return response;
          };
        })(this), function(error) {
          return $state.go('root.home');
        });
      }]
    }
  }).state('root.impressum', {
    url: '/impressum',
    views: {
      'body@': {
        templateUrl: 'assets/views/common/impressum.html'
      }
    }
  }).state('root.kontakt', {
    url: '/kontakt',
    views: {
      'body@': {
        templateUrl: 'assets/views/common/kontakt.html'
      }
    }
  }).state('root.agb', {
    url: '/nutzungsbedingungen',
    views: {
      'body@': {
        templateUrl: 'assets/views/common/agb.html'
      }
    }
  }).state('root.antimaas', {
    url: '/datenschutz',
    views: {
      'body@': {
        templateUrl: 'assets/views/common/datenschutz.html'
      }
    }
  }).state('root.register', {
    url: '/registration',
    views: {
      'body@': {
        templateUrl: 'assets/views/users/register.html',
        controller: 'RegistrationCtrl',
        controllerAs: 'reg'
      }
    },
    resolve: {
      companies: (function(_this) {
        return ["Company", function(Company) {
          return Company.getAll().then(function(response) {
            return response;
          }, function(error) {
            return error;
          });
        }];
      })(this)
    }
  }).state('root.login', {
    url: '/login',
    views: {
      'body@': {
        templateUrl: 'assets/views/users/login.html',
        controller: 'LoginCtrl',
        controllerAs: 'login'
      }
    }
  }).state('root.profile', {
    url: '/profile',
    params: {
      id: null
    },
    views: {
      'body@': {
        templateUrl: 'assets/views/users/profile.html',
        controller: 'ProfileCtrl',
        controllerAs: 'profile'
      }
    },
    resolve: {
      mydata: ["User", "$stateParams", "$state", function(User, $stateParams, $state) {
        return User.getUserPacket($stateParams.id).then(function(response) {
          return response.data;
        }, function(error) {
          return $state.go('root.home');
        });
      }],
      posts: ["User", "$stateParams", function(User, $stateParams) {
        return User.getInterests($stateParams.id).then(function(response) {
          return response.data;
        }, function(error) {
          return error;
        });
      }]
    }
  }).state('root.profile.edit', {
    url: '/edit',
    params: {
      id: null
    },
    views: {
      'body@': {
        templateUrl: 'assets/views/users/edit.html',
        controller: 'ProfileEditCtrl',
        controllerAs: 'predit'
      }
    },
    data: {
      permissions: {
        except: 'anonymous',
        redirectTo: 'root.home'
      }
    }
  }).state('root.profile.interests', {
    url: '/interests',
    views: {
      'subbody@': {
        templateUrl: 'assets/views/interests/list.html',
        controller: 'InterestsCtrl',
        controllerAs: 'interests'
      }
    }
  }).state('root.company.cmpinterests', {
    url: '/companies/view/interests',
    params: {
      id: null
    },
    views: {
      'subbody@': {
        templateUrl: 'assets/views/interests/company.html',
        controller: 'CompanyInterestCtrl',
        controllerAs: 'cmpint'
      }
    }
  }).state('root.interest', {
    url: '',
    abstract: true,
    params: {
      id: null
    },
    views: {
      'body@': {
        templateUrl: 'assets/views/interests/view.html',
        controller: 'InterestCtrl',
        controllerAs: 'intrst'
      }
    },
    resolve: {
      info: ["Interests", "$stateParams", "Helper", function(Interests, $stateParams, Helper) {
        return Interests.getInterest($stateParams.id).then((function(_this) {
          return function(response) {
            return response.data;
          };
        })(this), function(error) {
          if (error.status !== 401) {
            return Helper.goBack();
          }
        });
      }]
    }
  }).state('root.interest.hidden', {
    url: '/interest',
    templateUrl: 'assets/views/interests/hidden.html',
    controller: 'InterestHiddenCtrl',
    controllerAs: 'ctrl'
  }).state('root.interest.revealed', {
    url: '/interest/contact',
    data: {
      permissions: {
        except: 'anonymous',
        redirectTo: 'root.interest.hidden'
      }
    },
    templateUrl: 'assets/views/interests/revealed.html',
    controller: 'InterestRevealedCtrl',
    controllerAs: 'ctrl',
    resolve: {
      contact: ["Interests", "$stateParams", function(Interests, $stateParams) {
        return Interests.makeContact($stateParams.id).then((function(_this) {
          return function(response) {
            return response.data;
          };
        })(this), function(error) {
          return error;
        });
      }]
    }
  }).state('root.interest.createinterest', {
    url: '/create',
    views: {
      'body@': {
        templateUrl: 'assets/views/interests/create.html',
        controller: 'NewPostCtrl',
        controllerAs: 'npost'
      }
    },
    data: {
      permissions: {
        except: 'anonymous',
        redirectTo: 'root.register'
      }
    }
  }).state('root.interest.editinterest', {
    url: '/edit',
    params: {
      id: null
    },
    data: {
      permissions: {
        except: 'anonymous',
        redirectTo: 'root.home'
      }
    },
    views: {
      'body@': {
        templateUrl: 'assets/views/interests/edit.html',
        controller: 'InterestEditCtrl',
        controllerAs: 'intedit'
      }
    }
  }).state('root.companies', {
    url: '/companies',
    views: {
      'body@': {
        templateUrl: 'assets/views/companies/companies.html',
        controller: 'CompaniesCtrl',
        controllerAs: 'cmps'
      }
    },
    resolve: {
      list: ["Company", function(Company) {
        return Company.getApproved().then(function(result) {
          return result;
        }, function(error) {
          return [];
        });
      }]
    }
  }).state('root.companies.company', {
    url: '/view',
    views: {
      'body@': {
        templateUrl: 'assets/views/companies/company.html',
        controller: 'CompanyCtrl',
        controllerAs: 'cmp'
      }
    }
  }).state('root.companies.newcomp', {
    url: '/create',
    data: {
      permissions: {
        only: 'admin',
        redirectTo: 'root.home'
      }
    },
    views: {
      'body@': {
        templateUrl: 'assets/views/companies/create.html',
        controller: 'NewCompanyCtrl',
        controllerAs: 'ncomp'
      }
    }
  }).state('root.admin', {
    url: '/admin',
    abstract: true,
    data: {
      permissions: {
        only: 'admin',
        redirectTo: 'root.home'
      }
    }
  }).state('root.admin.userlist', {
    url: '/users',
    views: {
      'body@': {
        templateUrl: 'assets/views/admin/users.html',
        controller: 'UserListCtrl',
        controllerAs: 'users'
      }
    },
    resolve: {
      users: ["User", function(User) {
        return User.getAll().then(function(response) {
          return response;
        }, function(error) {
          return error;
        });
      }]
    }
  }).state('root.admin.interestlist', {
    url: '/interests',
    views: {
      'body@': {
        templateUrl: 'assets/views/admin/interests.html',
        controller: 'InterestListCtrl',
        controllerAs: 'interests'
      }
    },
    resolve: {
      interest: ["Interests", function(Interests) {
        return Interests.getAll().then(function(response) {
          return response;
        }, function(error) {
          return error;
        });
      }]
    }
  }).state('root.admin.companylist', {
    url: '/companies',
    views: {
      'body@': {
        templateUrl: 'assets/views/admin/companies.html',
        controller: 'CompanyListCtrl',
        controllerAs: 'companies'
      }
    }
  }).state('root.admin.statistics', {
    url: '/statistics',
    views: {
      'body@': {
        templateUrl: 'assets/views/admin/statistics.html',
        controller: 'StatisticsCtrl',
        controllerAs: 'stats'
      }
    }
  });
}]);

angular.module('mediMeet').directive('onScrollToBottom', (function(_this) {
  return ["$document", "$window", function($document, $window) {
    return {
      restrict: 'A',
      link: function(scope, element, attrs) {
        $document.bind("scroll", (function(_this) {
          return function() {
            if ($window.pageYOffset + $window.innerHeight >= $document.height()) {
              return scope.$apply(attrs.onScrollToBottom);
            }
          };
        })(this));
        return scope.$on('$destroy', function() {
          return $document.unbind('scroll');
        });
      }
    };
  }];
})(this));

angular.module('mediMeet').directive('tooltips', (function(_this) {
  return ["$document", "$window", function($document, $window) {
    return {
      restrict: 'A',
      link: function(scope, element, attrs) {
        return $document.bind("scroll", (function(_this) {
          return function() {
            return $document.ready(function() {
              $('[data-toggle="tooltip"]').tooltip();
              return $('[data-toggle="popover"]').popover();
            });
          };
        })(this));
      }
    };
  }];
})(this));

angular.module('mediMeet').factory('Keywords', function() {
  this.categories = ["Hospital/IT 4.0", "Medizintechnik 4.0", "Facility Management 4.0", "Klinische Prozesse 4.0"];
  this.subcategories = ["Cloud/IT-Services/Big Data", "Mobile Anwendungen", "Daten-/Dokumentenaustausche", "Cyber-Security & Privacy", "Interoperabilität", "Assistenzsysteme", "Wartung und Service", "Usability", "IT-gestützte Instandhaltung", "IoT im Krankenhaus", "Blue/Green Hospital", "Supply-Chain-Management", "e-Health/Medical Apps", "Digitale Versorgungsplattform", "Qualitäts-/Leistungserfassung", "Integrierte Prozesse"];
  this.keywords = ["IT-Services", "Digital Twin", "Big Data", "Connected Medical Devices", "Mobile Anwendungen/Mobile Devices", "Clinical Decision Support", "Daten- und Dokumentenaustausch", "Condition Monitoring", "Cyber-Security/IT-Sicherheit", "Telemedizin", "Safety/Funktionssicherheit", "personalisierte Medizin", "Datenschutz/Privacy", "elektronische Patientenakte (EPA)", "IT-gestützte Instandhaltung/Computerized Maintenance", "Medizingeräte/Medical Devices", "Internet of Things", "Cyber-physical-systems (CPS)", "Sustainability/Nachhaltigkeit", "Krankenhausinformationssystem (KIS)", "Green-/Blue-Hospital", "Predicitve Maintenance", "Supply-Chain-Management", "Processing", "Logistik", "Clinical Pathways/Behandlungspfade", "Interoperabilität", "Assistenzsysteme", "Wartung und Service", "Usability", "e-Health", "Medical Apps", "Clinical Unified Collaboration", "Qualitätsmanagement"];
  this.relations = [
    {
      category: "Hospital/IT 4.0",
      subcategories: [
        {
          subcategory: "Cloud/IT-Services/Big Data",
          keywords: ["Cloud", "IT-Services", "Big Data", "Internet of Things", "Cyber-Security/IT-Sicherheit", "Daten-und Dokumentenaustausch"]
        }, {
          subcategory: "Mobile Anwendungen",
          keywords: ["Mobile Anwendungen/Mobile Devices", "Medical Apps", "e-Health", "Connected Medical Devices", "elektronische Patientenakte (EPA)", "Krankenhausinformationssystem (KIS)"]
        }, {
          subcategory: "Daten-/Dokumentenaustausche",
          keywords: ["Daten- und Dokumentenaustausch", "elektronische Patientenakte (EPA)", "Krankenhausinformationssystem (KIS)", "Qualitätsmanagement"]
        }, {
          subcategory: "Cyber-Security & Privacy",
          keywords: ["Cyber-Security/IT-Sicherheit", "Safety/Funktionssicherheit", "Datenschutz/Privacy Cloud"]
        }
      ]
    }, {
      category: "Medizintechnik 4.0",
      subcategories: [
        {
          subcategory: "Interoperabilität",
          keywords: ["Interoperabilität", "Medizingeräte/Medical Devices", "Connected Medical Devices"]
        }, {
          subcategory: "Assistenzsysteme",
          keywords: ["Assistenzsysteme", "Cyber-physical-systems (CPS)"]
        }, {
          subcategory: "Wartung und Service",
          keywords: ["Wartung und Service", "Condition Monitoring", "Predicitve Maintenance"]
        }, {
          subcategory: "Usability",
          keywords: ["Usability", "Connected Medical Devices", "Cyber-physical-systems (CPS)", "Telemedizin"]
        }
      ]
    }, {
      category: "Facility Management 4.0",
      subcategories: [
        {
          subcategory: "IT-gestützte Instandhaltung",
          keywords: ["IT-gestützte Instandhaltung/Computerized Maintenance", "Condition Monitoring", "Predicitve Maintenance", "Internet of Things", "Smart Device"]
        }, {
          subcategory: "IoT im Krankenhaus",
          keywords: ["Internet of Things", "Smart Devices", "Digital Twin", "Cloud", "elektronische Patienteakte", "connected medical device", "clinical decision support", "Telemedzin", "Cyber-physical-systems (CPS)"]
        }, {
          subcategory: "Blue/Green Hospital",
          keywords: ["Nachhaltigkeit/Sustainability", "Green-/Blue-Hospital", "Supply-Chain-Management", "Clinical Pathways", "Internet of Things", "Qualitätsmanagement"]
        }, {
          subcategory: "Supply-Chain-Management",
          keywords: ["Supply-Chain-Management", "Logistik", "Mobile Anwendungen/Mobile Devices", "Internet of Things", "Medical Apps", "Qualitätsmanagement", "Smart Devices"]
        }
      ]
    }, {
      category: "Klinische Prozesse 4.0",
      subcategories: [
        {
          subcategory: "e-Health/Medical Apps",
          keywords: ["e-Health", "Medical Apps", "personalisierte Medizin", "elektronische Patientenakte (EPA)", "Telemedizin", "Smart Devices", "Internet of Things", "Datenschutz", "Usability"]
        }, {
          subcategory: "Digitale Versorgungsplattform",
          keywords: ["IT-Service", "Daten- und Dokumentenaustausch", "Interoperabilität", "Usability", "Integrierte Prozesse", "Telemedizin"]
        }, {
          subcategory: "Qualitäts-/Leistungserfassung",
          keywords: ["Qualitätsmanagement", "Daten- und Dokumentenaustausch", "Datenschutz/Privacy", "elektronische Patientenakte (EPA)"]
        }, {
          subcategory: "Integrierte Prozesse",
          keywords: ["Clinical Pathways/Behandlungspfade", "Krankenhausinformationssystem (KIS)", "Qualitätsmanagement"]
        }
      ]
    }
  ];
  return {
    categories: this.categories,
    subcategories: this.subcategories,
    keywords: this.keywords,
    relations: this.relations
  };
});

angular.module('mediMeet').factory('mediREST', ["Rails", "Restangular", function(Rails, Restangular) {
  return Restangular.withConfig(function(RestangularConfigurer) {
    var host;
    host = "" + Rails.database;
    RestangularConfigurer.setBaseUrl('/api/v1');
    RestangularConfigurer.setDefaultHeaders({
      'Content-Type': 'application/json'
    });
    return RestangularConfigurer.setRequestSuffix('.json');
  });
}]);

angular.module('mediMeet').service('Company', ["mediREST", "$q", "Upload", "Rails", function(mediREST, $q, Upload, Rails) {
  var approve, createCompany, destroy, getAll, getApproved, getOne, update;
  createCompany = function(company) {
    var defer;
    defer = $q.defer();
    Upload.upload({
      url: ("" + Rails.host) + '/api/v1/companies/',
      data: {
        data: company
      }
    }).then((function(_this) {
      return function(response) {
        return defer.resolve(response.data);
      };
    })(this), (function(_this) {
      return function(error) {
        return defer.reject(error);
      };
    })(this));
    return defer.promise;
  };
  getAll = function() {
    var defer, packet;
    defer = $q.defer();
    packet = mediREST.one('companies');
    packet.get().then((function(_this) {
      return function(response) {
        return defer.resolve(response.data);
      };
    })(this), (function(_this) {
      return function(error) {
        return defer.reject(error);
      };
    })(this));
    return defer.promise;
  };
  getApproved = function() {
    var defer, packet;
    defer = $q.defer();
    packet = mediREST.one('companies').one('approve');
    packet.get().then((function(_this) {
      return function(response) {
        return defer.resolve(response.data);
      };
    })(this), (function(_this) {
      return function(error) {
        return defer.reject(error);
      };
    })(this));
    return defer.promise;
  };
  getOne = function(id) {
    var defer, packet;
    defer = $q.defer();
    packet = mediREST.one('companies');
    packet.id = id;
    packet.get().then((function(_this) {
      return function(response) {
        return defer.resolve(response);
      };
    })(this), (function(_this) {
      return function(error) {
        return defer.reject(error);
      };
    })(this));
    return defer.promise;
  };
  update = function(company) {
    var defer, packet;
    defer = $q.defer();
    packet = company;
    packet.put().then((function(_this) {
      return function(response) {
        return defer.resolve(response);
      };
    })(this), (function(_this) {
      return function(error) {
        return defer.reject(error);
      };
    })(this));
    return defer.promise;
  };
  approve = function(id) {
    var defer, packet;
    defer = $q.defer();
    packet = mediREST.one('companies').one('approve');
    packet.id = id;
    packet.put().then((function(_this) {
      return function(response) {
        return defer.resolve(response);
      };
    })(this), (function(_this) {
      return function(error) {
        return defer.reject(error);
      };
    })(this));
    return defer.promise;
  };
  destroy = function(id) {
    var defer, packet;
    defer = $q.defer();
    packet = mediREST.one('companies');
    packet.id = id;
    packet.remove().then((function(_this) {
      return function(response) {
        return defer.resolve(response);
      };
    })(this), (function(_this) {
      return function(error) {
        return defer.reject(error);
      };
    })(this));
    return defer.promise;
  };
  return {
    createCompany: createCompany,
    getAll: getAll,
    getApproved: getApproved,
    getOne: getOne,
    update: update,
    approve: approve,
    destroy: destroy
  };
}]);

angular.module('mediMeet').service('Helper', ["$rootScope", "$state", function($rootScope, $state) {
  var goBack;
  goBack = function(defaultRoute) {
    var prev, prevParams;
    prev = $rootScope.lastState;
    prevParams = $rootScope.lastStateParams;
    console.log(prev.name);
    return $state.go(prev.name, prevParams);
  };
  return {
    goBack: goBack
  };
}]);

angular.module('mediMeet').service('Interests', ["mediREST", "$q", function(mediREST, $q) {
  var createInterest, deleteInterest, editInterest, getAll, getByCategory, getInterest, getKeywords, makeContact;
  createInterest = function(interest) {
    var defer, packet;
    defer = $q.defer();
    packet = mediREST.one('interests');
    packet.data = interest;
    packet.post().then(function(response) {
      console.log('Interest posted');
      return defer.resolve(response.data);
    }, function(error) {
      return defer.reject(error.data.error);
    });
    return defer.promise;
  };
  getAll = function() {
    var defer, packet;
    defer = $q.defer();
    packet = mediREST.one('interests');
    packet.get().then(function(response) {
      console.log('Got Interests');
      return defer.resolve(response.data);
    }, function(error) {
      console.log('Interest Error');
      return defer.reject(error.data.error);
    });
    return defer.promise;
  };
  getByCategory = function(category) {
    var defer, packet, params;
    defer = $q.defer();
    packet = mediREST.one('interests').one('category');
    params = {
      category: category
    };
    packet.customGET("", params).then(function(response) {
      return defer.resolve(response.data);
    }, function(error) {
      return defer.reject(error.data);
    });
    return defer.promise;
  };
  getInterest = function(id) {
    var defer, packet;
    defer = $q.defer();
    packet = mediREST.one('interests');
    packet.id = id;
    packet.get().then(function(response) {
      return defer.resolve(response);
    }, function(error) {
      return defer.reject(error);
    });
    return defer.promise;
  };
  makeContact = function(id) {
    var defer, packet;
    defer = $q.defer();
    packet = mediREST.one('interests').one('contact');
    packet.id = id;
    packet.get().then(function(response) {
      return defer.resolve(response);
    }, function(error) {
      return defer.reject(error);
    });
    return defer.promise;
  };
  getKeywords = function() {
    var defer, packet;
    defer = $q.defer();
    packet = mediREST.one('interests').one('keywords');
    packet.get().then(function(response) {
      return defer.resolve(response.data);
    }, function(error) {
      return defer.reject(error);
    });
    return defer.promise;
  };
  editInterest = function(interest) {
    var defer, packet;
    defer = $q.defer();
    packet = interest;
    packet.put().then(function(response) {
      console.log('editInterest');
      return defer.resolve(response);
    }, function(error) {
      return defer.reject(error);
    });
    return defer.promise;
  };
  deleteInterest = function(id) {
    var defer, packet;
    defer = $q.defer();
    packet = mediREST.one('interests');
    packet.id = id;
    packet.remove().then(function(response) {
      return defer.resolve(response);
    }, function(error) {
      return defer.reject(error);
    });
    return defer.promise;
  };
  return {
    createInterest: createInterest,
    getAll: getAll,
    getInterest: getInterest,
    makeContact: makeContact,
    getKeywords: getKeywords,
    getByCategory: getByCategory,
    editInterest: editInterest,
    deleteInterest: deleteInterest
  };
}]);

angular.module('mediMeet').service('SharedData', function() {
  var content, deleteValue, getValue, setValue;
  content = {};
  setValue = (function(_this) {
    return function(key, value) {
      return content[key] = value;
    };
  })(this);
  getValue = (function(_this) {
    return function(key) {
      return content[key];
    };
  })(this);
  deleteValue = (function(_this) {
    return function(key) {
      return content[key] = null;
    };
  })(this);
  return {
    setValue: setValue,
    getValue: getValue,
    deleteValue: deleteValue
  };
});

angular.module('mediMeet').service('TokenContainer', ["$localStorage", "Rails", "$rootScope", "$timeout", function($localStorage, Rails, $rootScope, $timeout) {

  /**
   *
   *
   * @param {[type]} token [description]
   */
  var _stillValid, deleteToken, get, getRaw, set;
  set = function(response) {
    var currDate, expiresAt, token;
    token = {
      token: response.access_token,
      expiresIn: response.expires_in,
      refreshToken: response.refresh_token
    };
    currDate = +new Date();
    expiresAt = currDate + (token.expiresIn * 1000);
    return $localStorage.token = angular.extend(token, {
      expiresAt: expiresAt
    });
  };

  /**
   *
   *
   * @return {[type]} [description]
   */
  get = function() {
    var token;
    if (token = _stillValid()) {
      return token.token;
    } else {
      return null;
    }
  };
  getRaw = function() {
    var token;
    if (token = _stillValid()) {
      return token;
    } else {
      return null;
    }
  };
  _stillValid = function() {
    var token;
    token = $localStorage.token;
    if (token) {
      return token;
    } else {
      return null;
    }
  };
  deleteToken = function() {
    delete $localStorage.token;
    return $timeout(function() {
      $rootScope.$broadcast('user:token_invalid');
      return $rootScope.$broadcast('user:stateChanged');
    });
  };
  return {
    get: get,
    getRaw: getRaw,
    set: set,
    "delete": deleteToken
  };
}]);

angular.module('mediMeet').service('User', ["mediREST", "$q", "$http", "Rails", "$rootScope", function(mediREST, $q, $http, Rails, $rootScope) {
  var deleteUser, getAll, getInterests, getRoles, getUser, getUserPacket, isAuthenticated, logout, registerUser, retrieveUser, updateUser, users;
  users = mediREST.one('users');
  this.user = null;
  this.deferreds = {};
  this.unauthorized = true;
  registerUser = function(user) {
    var defer;
    defer = $q.defer();
    users.data = user;
    users.post().then(function(response) {
      return defer.resolve(response.data);
    }, function(error) {
      return defer.reject(response.data);
    });
    return defer.promise;
  };
  getAll = function() {
    var defer;
    defer = $q.defer();
    users.get().then(function(results) {
      return defer.resolve(results.data);
    }, function(error) {
      return defer.reject(error);
    });
    return defer.promise;
  };
  getUser = function(id) {
    var defer, packet;
    defer = $q.defer();
    packet = mediREST.one('users');
    if (!id) {
      packet.id = 'me';
    } else {
      packet.id = id;
    }
    packet.get().then(function(response) {
      return defer.resolve(response.data);
    }, function(error) {
      return defer.reject(response.error);
    });
    return defer.promise;
  };
  getUserPacket = function(id) {
    var defer, packet;
    defer = $q.defer();
    packet = mediREST.one('users');
    if (!id) {
      packet.id = 'me';
    } else {
      packet.id = id;
    }
    packet.get().then(function(response) {
      return defer.resolve(response);
    }, function(error) {
      return defer.reject(response);
    });
    return defer.promise;
  };
  retrieveUser = (function(_this) {
    return function() {
      var defer, packet;
      defer = $q.defer();
      if (isAuthenticated()) {
        defer.resolve(_this.user);
        return defer.promise;
      } else if (_this.deferreds.me) {
        return _this.deferreds.me.promise;
      } else {
        _this.deferreds.me = defer;
        packet = mediREST.one('users');
        packet.id = 'me';
        packet.get().then(function(response) {
          _this.unauthorized = false;
          _this.user = response.data;
          _this.deferreds.me.resolve(response.data);
          return delete _this.deferreds.me;
        }, function(error) {
          _this.deferreds.me.reject();
          return delete _this.deferreds.me;
        });
        return _this.deferreds.me.promise;
      }
    };
  })(this);
  getRoles = (function(_this) {
    return function() {
      var defer;
      defer = $q.defer();
      if (isAuthenticated()) {
        defer.resolve(_this.user.roles);
      } else {
        retrieveUser().then(function(user) {
          return defer.resolve(user.roles);
        }, function() {
          return defer.reject();
        });
      }
      return defer.promise;
    };
  })(this);
  getInterests = (function(_this) {
    return function(id) {
      var defer, packet;
      defer = $q.defer();
      packet = mediREST.one('users').one('interests');
      if (id) {
        packet.id = id;
      } else {
        packet.id = _this.user.id;
      }
      packet.get().then(function(response) {
        return defer.resolve(response);
      }, function(error) {
        return defer.reject(error);
      });
      return defer.promise;
    };
  })(this);
  updateUser = (function(_this) {
    return function(user) {
      var defer, packet;
      console.log(user);
      packet = mediREST.one('users');
      defer = $q.defer();
      Object.assign(packet, user.data[0]);
      user.put().then(function(response) {
        if (response.status === 422) {
          return defer.reject(response.data);
        } else {
          console.log('golden!');
          return defer.resolve(response.data.data);
        }
      });
      return defer.promise;
    };
  })(this);
  logout = (function(_this) {
    return function() {
      var defer, packet;
      defer = $q.defer();
      packet = mediREST.all('users').one('logout');
      packet.remove().then(function(response) {
        _this.user = null;
        console.log(_this.user);
        _this.unauthorized = true;
        return defer.resolve(response);
      }, function(error) {
        return defer.reject(error);
      });
      return defer.promise;
    };
  })(this);
  deleteUser = (function(_this) {
    return function(id) {
      var defer, packet;
      defer = $q.defer();
      packet = mediREST.one('users');
      packet.id = id;
      packet.remove().then(function(response) {
        if (response.status === 401) {
          _this.unauthorized = true;
          return defer.reject(response.data);
        } else {
          return defer.resolve();
        }
      });
      return defer.promise;
    };
  })(this);
  isAuthenticated = (function(_this) {
    return function() {
      return !_this.unauthorized && (_this.user != null);
    };
  })(this);
  return {
    getAll: getAll,
    getUser: getUser,
    getUserPacket: getUserPacket,
    getRoles: getRoles,
    getInterests: getInterests,
    retrieveUser: retrieveUser,
    updateUser: updateUser,
    logout: logout,
    deleteUser: deleteUser,
    registerUser: registerUser,
    isAuthenticated: isAuthenticated
  };
}]);

angular.module('mediMeet').controller('CompanyListCtrl', ["$state", "Company", "$scope", function($state, Company, $scope) {
  this.resetSettings = (function(_this) {
    return function() {
      _this.finishedLoading = false;
      return _this.companyList = [];
    };
  })(this);
  this.resetSettings();
  this.init = (function(_this) {
    return function() {
      return Company.getAll().then(_this.compsReceived, function() {
        return console.log("Couldn't retrieve companies.");
      });
    };
  })(this);
  this.compsReceived = (function(_this) {
    return function(comps) {
      _this.finishedLoading = true;
      _this.companyList = angular.copy(comps);
      return console.log(_this.companyList);
    };
  })(this);
  this.getCompany = (function(_this) {
    return function(id) {
      return $state.go('root.companies.company', {
        id: id
      });
    };
  })(this);
  this.approveCompany = (function(_this) {
    return function(cmp) {
      return Company.approve(cmp.id).then(function(response) {
        return cmp.validated = true;
      }, function(error) {
        return console.log(error);
      });
    };
  })(this);
  this.deleteCompany = (function(_this) {
    return function(cmp) {
      return Company.destroy(cmp.id).then(function(response) {
        return _this.companyList.splice(_this.companyList.indexOf(cmp), 1);
      }, function(error) {
        return console.log(error);
      });
    };
  })(this);
  this.init();
  return this;
}]);

angular.module('mediMeet').controller('InterestListCtrl', ["$state", "User", "Interests", "$scope", "interest", function($state, User, Interests, $scope, interest) {
  this.posts = interest;
  this.edit = (function(_this) {
    return function(id) {
      return $state.go('root.interest.editinterest', {
        id: id
      });
    };
  })(this);
  this.viewPost = (function(_this) {
    return function(id) {
      return $state.go('root.interest.hidden', {
        id: id
      });
    };
  })(this);
  this.getUser = (function(_this) {
    return function(id) {
      return $state.go('root.interest', {
        id: id
      });
    };
  })(this);
  this.deletePost = (function(_this) {
    return function(post) {
      return Interests.deleteInterest(post.id).then(function(response) {
        var index;
        index = _this.posts.indexOf(post);
        return _this.posts.splice(index, 1);
      }, function(error) {
        return console.log('Error while deleting Post.');
      });
    };
  })(this);
  return this;
}]);



angular.module('mediMeet').controller('UserListCtrl', ["$state", "User", "$scope", "users", function($state, User, $scope, users) {
  this.resetSettings = (function(_this) {
    return function() {
      _this.finishedLoading = false;
      return _this.userList = users;
    };
  })(this);
  this.resetSettings();
  this.init = (function(_this) {
    return function() {
      _this.reverse = false;
      return User.getAll().then(_this.usersReceived, function() {
        return console.log("Couldn't retrieve userlist.");
      });
    };
  })(this);
  this.usersReceived = (function(_this) {
    return function(users) {
      _this.finishedLoading = true;
      return _this.userList = angular.copy(users);
    };
  })(this);
  this.getUser = (function(_this) {
    return function(id) {
      return $state.go('root.profile', {
        id: id
      });
    };
  })(this);
  this.deleteUser = (function(_this) {
    return function(user) {
      return User.deleteUser(user.id).then(function(response) {
        var index;
        index = _this.userList.indexOf(user);
        return _this.userList.splice(index, 1);
      });
    };
  })(this);
  return this;
}]);

angular.module('mediMeet').controller('CompaniesCtrl', ["Company", "list", function(Company, list) {
  this.companyList = list;
  console.log(this.companyList);
  return this;
}]);



angular.module('mediMeet').controller('HomeCtrl', ["$state", "Interests", function($state, Interests) {
  console.log("HomeCtrl active.");
  this.keywords = [];
  this.init = (function(_this) {
    return function() {
      return Interests.getKeywords().then(function(response) {
        console.log(response);
        return _this.keywords = response;
      }, function(error) {
        return console.log(error);
      });
    };
  })(this);
  this.searchPage = (function(_this) {
    return function(category) {
      return $state.go('root.explore', {
        category: category
      });
    };
  })(this);
  this.init();
  return this;
}]);

var indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

angular.module('mediMeet').controller('NavCtrl', ["$timeout", "$scope", "mediREST", "User", "TokenContainer", "$state", "$rootScope", function($timeout, $scope, mediREST, User, TokenContainer, $state, $rootScope) {
  this.form = {};
  this.username = "default";
  this.admin = false;
  this.init = (function(_this) {
    return function() {
      _this.isAuthenticated = false;
      _this.setLoggedIn(TokenContainer.get());
      _this.setUsername();
      return _this.isAdmin();
    };
  })(this);
  this.login = (function(_this) {
    return function() {
      var packet;
      packet = mediREST.one('users').one('login');
      packet.data = {
        username: _this.form.user.username,
        password: _this.form.user.password
      };
      console.log(packet.data);
      return packet.post().then(function(response) {
        User.user = response.data.user;
        TokenContainer.set(response.data.token);
        return $rootScope.$broadcast('user:stateChanged');
      }, function(error) {
        if (error.status === 404) {
          return console.log("Account doesn't exist.");
        }
      });
    };
  })(this);
  this.setUsername = (function(_this) {
    return function() {
      console.log(_this.isAuthenticated);
      if (_this.isAuthenticated) {
        return User.retrieveUser().then(function(response) {
          return _this.username = angular.copy(response.username);
        }, function(error) {
          this.username = "Angemeldet";
          return console.log("setUsername: error");
        });
      }
    };
  })(this);
  this.setLoggedIn = (function(_this) {
    return function(isLoggedIn) {
      _this.isAuthenticated = !!isLoggedIn;
      return console.log('Logged In Status: ' + _this.isAuthenticated);
    };
  })(this);
  this.logout = (function(_this) {
    return function() {
      return User.logout().then(function() {
        TokenContainer["delete"]();
        return $state.go('root.home');
      });
    };
  })(this);
  this.isAdmin = (function(_this) {
    return function() {
      console.log(User.user);
      if (User.user) {
        console.log(User.user.roles);
        if (indexOf.call(User.user.roles, 'admin') >= 0) {
          return _this.admin = true;
        } else {
          return _this.admin = false;
        }
      } else {
        return _this.admin = false;
      }
    };
  })(this);
  $rootScope.$on('user:stateChanged', (function(_this) {
    return function(e, state, params) {
      _this.setLoggedIn(TokenContainer.get());
      _this.setUsername();
      return _this.isAdmin();
    };
  })(this));
  this.init();
  return this;
}]);

angular.module('mediMeet').controller('SearchCtrl', ["Interests", "$stateParams", "$state", "Keywords", "initials", "category", function(Interests, $stateParams, $state, Keywords, initials, category) {
  this.list = initials;
  this.category = category;
  this.subcategories = [];
  this.subfilter;
  this.page = 1;
  this.init = (function(_this) {
    return function() {
      var i, len, ref, rel, results;
      ref = Keywords.relations;
      results = [];
      for (i = 0, len = ref.length; i < len; i++) {
        rel = ref[i];
        if (rel.category === $stateParams.category) {
          _this.subcategories = rel.subcategories;
          break;
        } else {
          results.push(void 0);
        }
      }
      return results;
    };
  })(this);
  this.viewPost = (function(_this) {
    return function(id) {
      return $state.go('root.interest.hidden', {
        id: id
      });
    };
  })(this);
  this.loadMore = (function(_this) {
    return function() {
      console.log("Loading more content");
      return _this.page++;
    };
  })(this);
  this.init();
  return this;
}]);

angular.module('mediMeet').controller('NewCompanyCtrl', ["Company", "$state", function(Company, $state) {
  this.form = {
    company: {}
  };
  this.submit = (function(_this) {
    return function() {
      return Company.createCompany(_this.form.company).then(function(response) {
        return $state.go('root.admin.companylist');
      }, function(error) {
        return console.log(error);
      });
    };
  })(this);
  return this;
}]);



angular.module('mediMeet').controller('InterestCtrl', ["info", "$scope", "User", function(info, $scope, User) {
  this.interest = info;
  this.init = (function(_this) {
    return function() {
      if (_this.interest.user_id === User.user.id) {
        return $scope.myint = true;
      } else {
        return $scope.myint = false;
      }
    };
  })(this);
  this.init();
  return this;
}]);

angular.module('mediMeet').controller('InterestEditCtrl', ["Interests", "$state", "$stateParams", "Keywords", "Helper", function(Interests, $state, $stateParams, Keywords, Helper) {
  this.categories = Keywords.relations;
  this.category = null;
  this.subcategories = [];
  this.subcategory = null;
  this.keywords = [];
  this.form = {
    interest: {}
  };
  this.rest = {};
  this.init = (function(_this) {
    return function() {
      return Interests.getInterest($stateParams.id).then(_this.postReceived, function() {
        return $state.go('root.admin.users');
      });
    };
  })(this);
  this.postReceived = (function(_this) {
    return function(response) {
      var category, i, j, len, len1, ref, ref1, results1, subcategory;
      _this.rest = response;
      _this.form.interest = angular.copy(_this.rest.data);
      ref = _this.categories;
      for (i = 0, len = ref.length; i < len; i++) {
        category = ref[i];
        if (category.category === _this.form.interest.category) {
          _this.category = category;
          _this.subcategories = _this.category.subcategories;
          break;
        }
      }
      ref1 = _this.subcategories;
      results1 = [];
      for (j = 0, len1 = ref1.length; j < len1; j++) {
        subcategory = ref1[j];
        if (subcategory.subcategory === _this.form.interest.subcategory) {
          _this.subcategory = subcategory;
          _this.keywords = _this.subcategory.keywords;
          break;
        } else {
          results1.push(void 0);
        }
      }
      return results1;
    };
  })(this);
  this.changeCategory = (function(_this) {
    return function() {
      _this.subcategories = _this.category.subcategories;
      _this.subcategory = null;
      _this.keywords = [];
      return _this.form.interest.keywords = [];
    };
  })(this);
  this.changeSubcategory = (function(_this) {
    return function() {
      _this.keywords = _this.subcategory.keywords;
      return _this.form.interest.keywords = [];
    };
  })(this);
  this.update = (function(_this) {
    return function() {
      _this.form.interest.category = _this.category.category;
      _this.form.interest.subcategory = _this.subcategory.subcategory;
      _this.rest.data = _this.form.interest;
      return Interests.editInterest(_this.rest).then(function(results) {
        return Helper.goBack();
      }, function(error) {
        return console.log(error);
      });
    };
  })(this);
  this.abort = function() {
    return Helper.goBack();
  };
  this.init();
  return this;
}]);

angular.module('mediMeet').controller('InterestHiddenCtrl', ["$state", "$stateParams", "$scope", function($state, $stateParams, $scope) {
  this.mine = $scope.myint;
  this.reveal = function() {
    console.log('Click');
    return $state.go('root.interest.revealed');
  };
  this.edit = function() {
    return $state.go('root.interest.editinterest', {
      id: $stateParams.id
    });
  };
  return this;
}]);

angular.module('mediMeet').controller('InterestRevealedCtrl', ["contact", function(contact) {
  this.user = contact;
  this.init = (function(_this) {
    return function() {
      return Interests.makeContact($stateParams.id).then(function(response) {
        _this.user = angular.copy(response.data);
        return console.log(_this.user);
      });
    };
  })(this);
  return this;
}]);



angular.module('mediMeet').controller('NewPostCtrl', ["User", "Interests", "$state", "Keywords", "Helper", function(User, Interests, $state, Keywords, Helper) {
  this.categories = Keywords.relations;
  this.category = null;
  this.subcategories = [];
  this.subcategory = null;
  this.keywords = [];
  this.form = {
    interest: {}
  };
  this.changeCategory = (function(_this) {
    return function() {
      _this.subcategories = _this.category.subcategories;
      _this.subcategory = null;
      _this.keywords = [];
      return _this.form.interest.keywords = [];
    };
  })(this);
  this.changeSubcategory = (function(_this) {
    return function() {
      _this.keywords = _this.subcategory.keywords;
      return _this.form.interest.keywords = [];
    };
  })(this);
  this.create_post = (function(_this) {
    return function() {
      _this.form.interest.category = _this.category.category;
      _this.form.interest.subcategory = _this.subcategory.subcategory;
      return Interests.createInterest(_this.form.interest).then(function(response) {
        console.log(response);
        return $state.go('root.admin.interestlist');
      });
    };
  })(this);
  this.abort = function() {
    return Helper.goBack();
  };
  return this;
}]);

angular.module('mediMeet').controller('LoginCtrl', ["User", "TokenContainer", "mediREST", "$q", "$rootScope", "$state", function(User, TokenContainer, mediREST, $q, $rootScope, $state) {
  this.form = {};
  this.login = (function(_this) {
    return function() {
      var packet;
      packet = mediREST.one('users').one('login');
      packet.data = {
        email: _this.form.user.email,
        password: _this.form.user.password
      };
      console.log(packet.data);
      return packet.post().then(function(response) {
        User.user = response.data.user;
        TokenContainer.set(response.data.token);
        $rootScope.$broadcast('user:stateChanged');
        return $state.go('root.home');
      }, function(error) {
        if (error.status === 404) {
          return console.log("Account doesn't exist.");
        }
      });
    };
  })(this);
  return this;
}]);

var indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

angular.module('mediMeet').controller('ProfileCtrl', ["User", "$state", "$stateParams", "mydata", "posts", function(User, $state, $stateParams, mydata, posts) {
  console.log('Profile Controller Active');
  this.user = mydata;
  this.interestList = posts;
  this.id = $stateParams.id;
  this.canEdit = false;
  this.init = (function(_this) {
    return function() {
      if (User.user.id === _this.user.id || indexOf.call(User.user.roles, 'admin') >= 0) {
        return _this.canEdit = true;
      }
    };
  })(this);
  this.editProfile = (function(_this) {
    return function() {
      return $state.go('root.profile.edit', {
        id: _this.id
      });
    };
  })(this);
  this.getInterests = (function(_this) {
    return function() {
      if (!_this.interestList.length) {
        return User.getInterests(_this.id).then(_this.gotInterests, function() {
          return console.log("Error");
        });
      }
    };
  })(this);
  this.gotInterests = (function(_this) {
    return function(interests) {
      return _this.interestList = angular.copy(interests.data);
    };
  })(this);
  this.viewInterest = (function(_this) {
    return function(id) {
      return $state.go('root.interest.hidden', {
        id: id
      });
    };
  })(this);
  this.init();
  return this;
}]);

angular.module('mediMeet').controller('ProfileEditCtrl', ["$stateParams", "$state", "User", "Helper", function($stateParams, $state, User, Helper) {
  console.log('userEditCtrl active.');
  this.form = {
    user: {}
  };
  this.regInProgress = false;
  this.rest = {};
  this.init = (function(_this) {
    return function() {
      return User.getUserPacket($stateParams.id).then(_this.userReceived, function() {
        return $state.go('root.admin.users');
      });
    };
  })(this);
  this.userReceived = (function(_this) {
    return function(user) {
      console.log(user);
      _this.rest = user;
      return _this.form.user = angular.copy(_this.rest.data);
    };
  })(this);
  this.update = (function(_this) {
    return function() {
      _this.regInProgress = true;
      _this.rest.data = _this.form.user;
      return User.updateUser(_this.rest).then(function(results) {
        _this.submittedForm = false;
        return $state.go('root.profile', {
          id: $stateParams.id
        });
      }, function(error) {
        _this.regInProgress = false;
        return console.log(error);
      });
    };
  })(this);
  this.abort = function() {
    console.log("Aborting");
    return Helper.goBack();
  };
  this.init();
  return this;
}]);

angular.module('mediMeet').controller('RegistrationCtrl', ["TokenContainer", "User", "$state", "$scope", "$rootScope", "companies", "Helper", function(TokenContainer, User, $state, $scope, $rootScope, companies, Helper) {
  console.log('RegistrationCtrl active.');
  this.form = {
    user: {},
    contact_data: {}
  };
  this.regInProgress = false;
  this.errors = {};
  this.companies = companies;
  this.goBack = (function(_this) {
    return function() {
      return Helper.goBack();
    };
  })(this);
  this.register = (function(_this) {
    return function() {
      if (_this.validate()) {
        _this.regInProgress = true;
        if (_this.form.user.typus !== 'Student') {
          _this.form.user.contact_data = _this.form.contact_data;
        }
        return User.registerUser(_this.form.user).then(function(results) {
          _this.regInProgress = false;
          console.log('Registration Data');
          console.log(results);
          User.user = results.user;
          TokenContainer.set(results.token);
          $rootScope.$broadcast('user:stateChanged');
          return Helper.goBack();
        }, function(error) {
          console.log('Register Error');
          console.log(error);
          if (error.status === 404) {
            console.log('Email not found');
          }
          return _this.regInProgress = false;
        });
      } else {
        return console.log("Validation failed.");
      }
    };
  })(this);
  this.validate = (function(_this) {
    return function() {
      var c, u, valid;
      valid = true;
      _this.errors = {};
      u = _this.form.user;
      c = _this.form.contact_data;
      if (!u.typus) {
        _this.errors.typus = true;
        valid = false;
      }
      if (!(u.username && u.email && u.password && (u.password_confirmation === u.password))) {
        if (!u.username) {
          _this.errors.username = true;
        }
        if (!u.email) {
          _this.errors.email = true;
        }
        if (!u.password) {
          _this.errors.password = true;
        }
        if (!(u.password_confirmation && (u.password === u.password_confirmation))) {
          _this.errors.password_confirmation = true;
        }
        valid = false;
      }
      if (u.typus !== "Student") {
        if (!(c.firstname && c.lastname && c.plz && c.ort && (c.web || c.fon))) {
          if (!c.firstname) {
            _this.errors.firstname = true;
          }
          if (!c.lastname) {
            _this.errors.lastname = true;
          }
          if (!c.plz) {
            _this.errors.plz = true;
          }
          if (!c.ort) {
            _this.errors.ort = true;
          }
          if (!(c.web || c.fon)) {
            _this.errors.web = true;
            _this.errors.fon = true;
          }
          valid = false;
        }
        if (u.typus === "Firma") {
          if (!c.company_id) {
            _this.errors.company = true;
            valid = false;
          }
        }
      }
      return valid;
    };
  })(this);
  return this;
}]);

angular.module('mediMeet').factory('badrequestHandler', ["$injector", function($injector) {
  var handle;
  return handle = function(response, deferred) {
    deferred.reject(response);
    return deferred.promise;
  };
}]);

angular.module('mediMeet').factory('conflictHandler', ["$injector", function($injector) {
  var handle;
  return handle = function(response, deferred) {
    deferred.reject(response);
    return deferred.promise;
  };
}]);

angular.module('mediMeet').factory('forbiddenHandler', ["$injector", function($injector) {
  var handle;
  return handle = function(response, deferred) {
    deferred.reject(response);
    return deferred.promise;
  };
}]);

angular.module('mediMeet').factory('notfoundHandler', ["$injector", function($injector) {
  var handle;
  return handle = function(response, deferred) {
    deferred.reject(response);
    return deferred.promise;
  };
}]);

angular.module('mediMeet').factory('unauthorizedHandler', ["$injector", function($injector) {
  var handle;
  return handle = function(response, deferred) {
    var access, state;
    access = $injector.get('TokenContainer');
    state = $injector.get('$state');
    if (access.get()) {
      access["delete"]();
      state.go('root.home');
    } else {
      state.go('root.register');
    }
    deferred.reject(response);
    return deferred.promise;
  };
}]);

angular.module('mediMeet').factory('responseInterceptor', ["$q", "$injector", function($q, $injector) {
  return {
    responseError: (function(_this) {
      return function(response) {
        var deferred, handle;
        deferred = $q.defer();
        switch (response.status) {
          case 400:
            handle = $injector.get('badrequestHandler');
            return handle(response, deferred);
          case 401:
            handle = $injector.get('unauthorizedHandler');
            return handle(response, deferred);
          case 403:
            handle = $injector.get('forbiddenHandler');
            return handle(response, deferred);
          case 404:
            handle = $injector.get('notfoundHandler');
            return handle(response, deferred);
          case 409:
            handle = $injector.get('conflictHandler');
            return handle(response, deferred);
          default:
            console.log('Other Error');
            deferred.reject(response);
            return deferred.promise;
        }
        return response;
      };
    })(this)
  };
}]);

angular.module('mediMeet').factory('tokenInterceptor', ["TokenContainer", "Rails", function(TokenContainer, Rails) {
  return {
    request: function(config) {
      var token;
      if (config.url.indexOf("/api/v1/") === 0) {
        token = TokenContainer.get();
        if (token) {
          config.headers['Authorization'] = "Bearer " + token;
        }
      }
      return config;
    }
  };
}]);
