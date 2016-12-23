--Speedroid Vidroskull
--fixed by MLD
function c511009385.initial_effect(c)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(21250202,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_HAND)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetCountLimit(1)
	e3:SetCondition(c511009385.spcon)
	e3:SetTarget(c511009385.sptg)
	e3:SetOperation(c511009385.spop)
	c:RegisterEffect(e3)
	--reflect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_REFLECT_BATTLE_DAMAGE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	if not c511009385.global_check then
		c511009385.global_check=true
		c511009385[0]=true
		c511009385[1]=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c511009385.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ADJUST)
		ge2:SetCountLimit(1)
		ge2:SetOperation(c511009385.clear)
		Duel.RegisterEffect(ge2,0)
	end
end
function c511009385.cfilter(c,tp)
	return c:GetSummonPlayer()==1-tp and c:GetSummonLocation()==LOCATION_EXTRA
end
function c511009385.checkop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(c511009385.cfilter,1,nil,tp) then c511009385[tp]=true end
	if eg:IsExists(c511009385.cfilter,1,nil,1-tp) then c511009385[1-tp]=true end
end
function c511009385.clear(e,tp,eg,ep,ev,re,r,rp)
	c511009385[0]=false
	c511009385[1]=false
end
function c511009385.spcon(e,tp,eg,ep,ev,re,r,rp)
	return c511009385[tp] and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function c511009385.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c511009385.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0
		and Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) then
		Duel.SendtoGrave(c,REASON_RULE)
	end
end
