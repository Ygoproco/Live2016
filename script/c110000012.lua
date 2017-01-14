--オシリスの天空竜
function c110000012.initial_effect(c)
	--summon with 3 tribute
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_LIMIT_SUMMON_PROC)
	e1:SetCondition(c110000012.ttcon)
	e1:SetOperation(c110000012.ttop)
	e1:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_LIMIT_SET_PROC)
	e2:SetCondition(c110000012.setcon)
	c:RegisterEffect(e2)
	--summon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_DISABLE_SUMMON)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e3)
	--summon success
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetOperation(c110000012.sumsuc)
	c:RegisterEffect(e4)
	--to grave
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(10000020,0))
	e5:SetCategory(CATEGORY_TOGRAVE)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCode(EVENT_PHASE+PHASE_END)
	e5:SetCondition(c110000012.tgcon)
	e5:SetTarget(c110000012.tgtg)
	e5:SetOperation(c110000012.tgop)
	c:RegisterEffect(e5)
	--atk/def
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_SET_ATTACK)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetValue(c110000012.adval)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EFFECT_SET_DEFENSE)
	c:RegisterEffect(e7)
	--destroy
	local e8=Effect.CreateEffect(c)
	e8:SetCategory(CATEGORY_DESTROY)
	e8:SetDescription(aux.Stringid(10000020,1))
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCode(EVENT_SUMMON_SUCCESS)
	e8:SetTarget(c110000012.destg)
	e8:SetOperation(c110000012.desop)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
	local e10=e8:Clone()
	e10:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e10)
	--cannot be target
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e11:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e11:SetRange(LOCATION_MZONE)
	e11:SetValue(1)
	c:RegisterEffect(e11)
end
function c110000012.ttcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-3 and Duel.GetTributeCount(c)>=3
end
function c110000012.ttop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectTribute(tp,c,3,3)
	c:SetMaterial(g)
	Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
end
function c110000012.setcon(e,c)
	if not c then return true end
	return false
end
function c110000012.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetChainLimitTillChainEnd(aux.FALSE)
end
function c110000012.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL
end
function c110000012.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,e:GetHandler(),1,0,0)
end
function c110000012.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		Duel.SendtoGrave(c,REASON_EFFECT)
	end
end
function c110000012.adval(e,c)
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_HAND,0)*1000
end
function c110000012.filter(c,e,tp)
	return c:IsControler(1-tp) and c:IsFaceup() and (c:IsDefenseBelow(2000) or c:IsAttackBelow(2000)) and (not e or c:IsRelateToEffect(e))
end
function c110000012.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e) and eg:IsExists(c110000012.filter,1,nil,nil,tp)  end
	local g=eg:Filter(c110000012.filter,nil,nil,tp)
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c110000012.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c110000012.filter,nil,e,tp)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
