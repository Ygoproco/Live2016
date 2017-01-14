--Amazoness Audience Room
function c511002964.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c511002964.condition1)
	c:RegisterEffect(e1)
	--Activate (sp summon)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCondition(c511002964.condition2)
	e2:SetTarget(c511002964.target)
	c:RegisterEffect(e2)
	--trigger
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_RECOVER)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetTarget(c511002964.sptg)
	e3:SetOperation(c511002964.spop)
	c:RegisterEffect(e3)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EFFECT_SELF_DESTROY)
	e4:SetCondition(c511002964.descon)
	c:RegisterEffect(e4)
end
function c511002964.condition1(e,tp,eg,ep,ev,re,r,rp)
	local res,teg,tep,tev,tre,tr,trp=Duel.CheckEvent(EVENT_SPSUMMON_SUCCESS,true)
	return not res or not teg:IsExists(c511002964.tgfilter,1,nil,nil,tp)
end
function c511002964.condition2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c511002964.tgfilter,1,nil,nil,tp)
end
function c511002964.tgfilter(c,e,tp)
	return c:IsControler(1-tp) and (not e or c:IsRelateToEffect(e))
end
function c511002964.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if c511002964.sptg(e,tp,eg,ep,ev,re,r,rp,0) and Duel.SelectYesNo(tp,aux.Stringid(61965407,0)) then
		e:SetCategory(CATEGORY_RECOVER)
		e:SetOperation(c511002964.spop)
		c511002964.sptg(e,tp,eg,ep,ev,re,r,rp,1)
	else
		e:SetCategory(0)
		e:SetOperation(nil)
	end
end
function c511002964.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c511002964.tgfilter,1,nil,nil,tp) end
	local g=eg:Filter(c511002964.tgfilter,nil,nil,tp)
	Duel.SetTargetCard(eg)
	local sum=g:GetSum(Card.GetAttack)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,sum)
end
function c511002964.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local g=tg:Filter(c511002964.tgfilter,nil,e,tp)
	local sum=g:GetSum(Card.GetAttack)
	Duel.Recover(tp,sum,REASON_EFFECT)
end
function c511002964.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x4)
end
function c511002964.descon(e)
	return not Duel.IsExistingMatchingCard(c511002964.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
